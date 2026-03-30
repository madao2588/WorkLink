from datetime import UTC, datetime
from uuid import uuid4

from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.response import paginated_response, success_response
from app.db.session import get_db
from app.models.entities import Approval, User
from app.schemas.api import ApprovalActionRequest, CreateApprovalRequest

router = APIRouter()


def _approval_to_dict(approval: Approval, db: Session) -> dict:
    applicant = db.get(User, approval.applicant_id)
    return {
        "id": approval.id,
        "title": approval.title,
        "applicant": applicant.name if applicant else "未知用户",
        "applicantId": approval.applicant_id,
        "startTime": approval.start_time.isoformat(),
        "reason": approval.reason,
        "status": approval.status,
        "currentNodeName": approval.current_node_name,
    }


@router.get("/instances")
def approval_list(
    request: Request,
    status: str | None = Query(default=None),
    scope: str = Query(default="all"),
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    query = select(Approval)
    if status:
        query = query.where(Approval.status == status.upper())
    if scope == "mine":
        query = query.where(Approval.applicant_id == current_user.id)
    approvals = db.scalars(query.order_by(Approval.start_time.desc())).all()
    items = [_approval_to_dict(item, db) for item in approvals]
    total = len(items)
    start = (page - 1) * pageSize
    end = start + pageSize
    return success_response(request, paginated_response(page=page, page_size=pageSize, total=total, items=items[start:end]))


@router.get("/instances/{approval_id}")
def approval_detail(
    approval_id: str,
    request: Request,
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approval = db.get(Approval, approval_id)
    if not approval:
        return success_response(request, None, message="approval not found")
    applicant = db.get(User, approval.applicant_id)
    return success_response(
        request,
        {
            "id": approval.id,
            "title": approval.title,
            "templateCode": "generic_leave",
            "applicant": applicant.name if applicant else "未知用户",
            "applicantId": approval.applicant_id,
            "department": applicant.department.name if applicant else "",
            "status": approval.status,
            "startTime": approval.start_time.isoformat(),
            "reason": approval.reason,
            "formData": {"reason": approval.reason},
            "nodes": [{"nodeName": approval.current_node_name, "status": approval.status}],
            "logs": [],
            "attachments": [],
            "canApprove": approval.status == "PENDING",
            "canReject": approval.status == "PENDING",
            "canRevoke": approval.status == "PENDING",
        },
    )


@router.post("/instances")
def create_approval(
    payload: CreateApprovalRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approval = Approval(
        id=f"a_{uuid4().hex[:10]}",
        title=payload.title,
        applicant_id=current_user.id,
        start_time=datetime.now(UTC),
        reason=payload.reason,
        status="PENDING",
        current_node_name="直属主管审批",
    )
    db.add(approval)
    db.commit()
    return success_response(request, _approval_to_dict(approval, db))


@router.post("/instances/{approval_id}/approve")
def approve_approval(
    approval_id: str,
    _: ApprovalActionRequest,
    request: Request,
    __: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approval = db.get(Approval, approval_id)
    if approval:
        approval.status = "APPROVED"
        approval.current_node_name = "审批完成"
        db.commit()
    return success_response(request, {"id": approval_id, "status": "APPROVED"})


@router.post("/instances/{approval_id}/reject")
def reject_approval(
    approval_id: str,
    _: ApprovalActionRequest,
    request: Request,
    __: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approval = db.get(Approval, approval_id)
    if approval:
        approval.status = "REJECTED"
        approval.current_node_name = "审批驳回"
        db.commit()
    return success_response(request, {"id": approval_id, "status": "REJECTED"})


@router.post("/instances/{approval_id}/revoke")
def revoke_approval(
    approval_id: str,
    _: ApprovalActionRequest,
    request: Request,
    __: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approval = db.get(Approval, approval_id)
    if approval:
        approval.status = "REVOKED"
        approval.current_node_name = "申请人撤回"
        db.commit()
    return success_response(request, {"id": approval_id, "status": "REVOKED"})


@router.get("/summary")
def approval_summary(
    request: Request,
    _: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    approvals = db.scalars(select(Approval)).all()
    return success_response(
        request,
        {
            "pendingCount": len([item for item in approvals if item.status == "PENDING"]),
            "approvedCount": len([item for item in approvals if item.status == "APPROVED"]),
            "rejectedCount": len([item for item in approvals if item.status == "REJECTED"]),
            "todoCount": len([item for item in approvals if item.status == "PENDING"]),
        },
    )
