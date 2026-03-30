from datetime import UTC, datetime
from uuid import uuid4

from fastapi import APIRouter, Depends, Query, Request, WebSocket, WebSocketDisconnect
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.deps import get_current_user
from app.core.exceptions import NotFoundException
from app.core.response import paginated_response, success_response
from app.core.security import get_subject_from_token
from app.db.session import get_db
from app.models.entities import Conversation, ConversationMember, Message, User
from app.schemas.api import ConversationPreferenceRequest, MarkReadRequest, SendMessageRequest
from app.services.websocket_manager import connection_manager

router = APIRouter()


def _find_peer(conversation_id: str, current_user_id: str, db: Session) -> User:
    members = db.scalars(select(ConversationMember).where(ConversationMember.conversation_id == conversation_id)).all()
    peer_member = next((member for member in members if member.user_id != current_user_id), None)
    if not peer_member:
        raise NotFoundException(message="Peer not found")
    peer = db.get(User, peer_member.user_id)
    if not peer:
        raise NotFoundException(message="Peer not found")
    return peer


def _build_summary(conversation_id: str, current_user: User, db: Session) -> dict:
    conversation = db.get(Conversation, conversation_id)
    membership = db.scalar(
        select(ConversationMember).where(
            ConversationMember.conversation_id == conversation_id,
            ConversationMember.user_id == current_user.id,
        )
    )
    if not conversation or not membership:
        raise NotFoundException(message="Conversation not found")
    peer = _find_peer(conversation_id, current_user.id, db)
    latest_message = db.scalar(
        select(Message).where(Message.conversation_id == conversation_id).order_by(Message.sent_at.desc())
    )
    return {
        "conversationId": conversation.id,
        "conversationType": conversation.conversation_type,
        "userId": peer.id,
        "name": peer.name,
        "avatar": peer.avatar,
        "department": peer.department.name,
        "isOnline": peer.is_online,
        "latestPreview": latest_message.content if latest_message else "",
        "latestMessageTime": latest_message.sent_at.isoformat() if latest_message else None,
        "unreadCount": membership.unread_count,
        "isPinned": membership.is_pinned,
        "isMuted": membership.is_muted,
    }


@router.get("/conversations")
def conversation_list(
    request: Request,
    keyword: str | None = Query(default=None),
    onlyUnread: bool = Query(default=False),
    page: int = Query(default=1, ge=1),
    pageSize: int = Query(default=20, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    memberships = db.scalars(select(ConversationMember).where(ConversationMember.user_id == current_user.id)).all()
    items = [_build_summary(membership.conversation_id, current_user, db) for membership in memberships]
    if keyword:
        items = [
            item for item in items
            if keyword.lower() in item["name"].lower() or keyword.lower() in item["latestPreview"].lower()
        ]
    if onlyUnread:
        items = [item for item in items if item["unreadCount"] > 0]
    items.sort(
        key=lambda item: (
            item["isPinned"],
            item["latestMessageTime"] or "",
        ),
        reverse=True,
    )
    total = len(items)
    start = (page - 1) * pageSize
    end = start + pageSize
    return success_response(request, paginated_response(page=page, page_size=pageSize, total=total, items=items[start:end]))


@router.get("/conversations/{conversation_id}")
def conversation_detail(
    conversation_id: str,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    summary = _build_summary(conversation_id, current_user, db)
    return success_response(
        request,
        {
            "conversationId": summary["conversationId"],
            "conversationType": summary["conversationType"],
            "name": summary["name"],
            "avatar": summary["avatar"],
            "department": summary["department"],
            "isOnline": summary["isOnline"],
            "memberCount": 2,
        },
    )


@router.get("/conversations/{conversation_id}/messages")
def conversation_messages(
    conversation_id: str,
    request: Request,
    cursor: str | None = Query(default=None),
    pageSize: int = Query(default=50, ge=1, le=100),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    query = select(Message).where(Message.conversation_id == conversation_id)
    if cursor:
        try:
            cursor_dt = datetime.fromisoformat(cursor.replace("Z", "+00:00"))
            query = query.where(Message.sent_at < cursor_dt)
        except ValueError:
            pass
    messages = db.scalars(query.order_by(Message.sent_at.desc()).limit(pageSize)).all()
    items = []
    for message in reversed(messages):
        sender = db.get(User, message.sender_id)
        items.append(
            {
                "messageId": message.id,
                "conversationId": message.conversation_id,
                "senderId": message.sender_id,
                "senderName": sender.name if sender else "未知用户",
                "content": message.content,
                "messageType": message.message_type,
                "sentAt": message.sent_at.isoformat(),
                "isMe": message.sender_id == current_user.id,
                "isRead": True,
                "attachments": [],
            }
        )
    return success_response(request, items)


@router.post("/conversations/{conversation_id}/messages")
async def send_message(
    conversation_id: str,
    payload: SendMessageRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    message = Message(
        id=f"m_{uuid4().hex[:10]}",
        conversation_id=conversation_id,
        sender_id=current_user.id,
        content=payload.content,
        message_type=payload.messageType,
        client_message_id=payload.clientMessageId,
        sent_at=datetime.now(UTC),
    )
    db.add(message)
    conversation = db.get(Conversation, conversation_id)
    if conversation:
        conversation.latest_message_time = message.sent_at
    members = db.scalars(select(ConversationMember).where(ConversationMember.conversation_id == conversation_id)).all()
    peer_member = None
    for member in members:
        if member.user_id != current_user.id:
            member.unread_count += 1
            peer_member = member
    db.commit()

    if peer_member:
        await connection_manager.send_json(
            peer_member.user_id,
            {
                "event": "message.new",
                "conversationId": conversation_id,
                "message": {
                    "messageId": message.id,
                    "content": message.content,
                    "senderId": current_user.id,
                    "sentAt": message.sent_at.isoformat(),
                },
            },
        )

    return success_response(
        request,
        {
            "messageId": message.id,
            "clientMessageId": payload.clientMessageId,
            "sentAt": message.sent_at.isoformat(),
            "status": "SENT",
        },
    )


@router.post("/conversations/{conversation_id}/read")
def mark_read(
    conversation_id: str,
    payload: MarkReadRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    membership = db.scalar(
        select(ConversationMember).where(
            ConversationMember.conversation_id == conversation_id,
            ConversationMember.user_id == current_user.id,
        )
    )
    if not membership:
        raise NotFoundException(message="Conversation membership not found")
    membership.unread_count = 0
    membership.last_read_message_id = payload.lastReadMessageId
    db.commit()
    return success_response(request, {"updated": True})


@router.patch("/conversations/{conversation_id}/preferences")
def update_preferences(
    conversation_id: str,
    payload: ConversationPreferenceRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> dict:
    membership = db.scalar(
        select(ConversationMember).where(
            ConversationMember.conversation_id == conversation_id,
            ConversationMember.user_id == current_user.id,
        )
    )
    if not membership:
        raise NotFoundException(message="Conversation membership not found")
    if payload.isPinned is not None:
        membership.is_pinned = payload.isPinned
    if payload.isMuted is not None:
        membership.is_muted = payload.isMuted
    db.commit()
    return success_response(
        request,
        {
            "conversationId": conversation_id,
            "isPinned": membership.is_pinned,
            "isMuted": membership.is_muted,
        },
    )


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket) -> None:
    token = websocket.query_params.get("token")
    if not token:
        await websocket.close(code=1008)
        return
    user_id = get_subject_from_token(token)
    if not user_id:
        await websocket.close(code=1008)
        return

    await connection_manager.connect(user_id, websocket)
    try:
        await websocket.send_json({"event": "connected", "userId": user_id})
        while True:
            payload = await websocket.receive_json()
            await websocket.send_json({"event": "echo", "payload": payload})
    except WebSocketDisconnect:
        connection_manager.disconnect(user_id, websocket)
