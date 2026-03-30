from datetime import date

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models.entities import Approval, AttendanceRecord, ConversationMember, Message, Notification, User


def build_profile_overview(db: Session, user: User) -> dict:
    attendance = db.scalar(
        select(AttendanceRecord).where(
            AttendanceRecord.user_id == user.id,
            AttendanceRecord.record_date == date.today(),
        )
    )
    pending_count = db.scalar(
        select(func.count()).select_from(Approval).where(
            Approval.applicant_id == user.id,
            Approval.status == "PENDING",
        )
    ) or 0
    total_messages = db.scalar(
        select(func.count()).select_from(Message).join(
            ConversationMember, ConversationMember.conversation_id == Message.conversation_id
        ).where(ConversationMember.user_id == user.id)
    ) or 0
    unread_count = db.scalar(
        select(func.coalesce(func.sum(ConversationMember.unread_count), 0)).where(
            ConversationMember.user_id == user.id
        )
    ) or 0

    return {
        "user": {
            "id": user.id,
            "name": user.name,
            "avatar": user.avatar,
            "department": user.department.name,
            "isOnline": user.is_online,
        },
        "attendance": {
            "status": attendance.status if attendance else "NOT_CHECKED_IN",
            "hasCheckedIn": bool(attendance and attendance.check_in_time),
            "checkInTime": attendance.check_in_time.isoformat() if attendance and attendance.check_in_time else None,
        },
        "approval": {"pendingCount": pending_count},
        "chat": {"totalMessageCount": total_messages, "unreadCount": unread_count},
    }


def build_workplace_dashboard(db: Session, user: User) -> dict:
    today_record = db.scalar(
        select(AttendanceRecord).where(
            AttendanceRecord.user_id == user.id,
            AttendanceRecord.record_date == date.today(),
        )
    )
    pending_count = db.scalar(select(func.count()).select_from(Approval).where(Approval.status == "PENDING")) or 0
    unread_count = db.scalar(
        select(func.coalesce(func.sum(ConversationMember.unread_count), 0)).where(
            ConversationMember.user_id == user.id
        )
    ) or 0
    notices = db.scalars(
        select(Notification).where(Notification.user_id == user.id).order_by(Notification.created_at.desc()).limit(3)
    ).all()

    return {
        "greeting": f"{user.name}，欢迎回来",
        "dateLabel": date.today().isoformat(),
        "attendanceCard": {
            "status": today_record.status if today_record else "NOT_CHECKED_IN",
            "hasCheckedIn": bool(today_record and today_record.check_in_time),
            "checkInTime": today_record.check_in_time.isoformat() if today_record and today_record.check_in_time else None,
        },
        "approvalCard": {"pendingCount": pending_count, "title": "待审批事项"},
        "messageCard": {"unreadCount": unread_count, "title": "消息提醒"},
        "noticeCards": [
            {
                "id": notice.id,
                "title": notice.title,
                "content": notice.content,
                "type": notice.type,
                "createdAt": notice.created_at.isoformat(),
            }
            for notice in notices
        ],
        "shortcutCards": [
            {"code": "approval", "title": "审批中心", "subtitle": "查看待办和已办"},
            {"code": "attendance", "title": "考勤打卡", "subtitle": "查看今日签到状态"},
            {"code": "contacts", "title": "通讯录", "subtitle": "快速联系同事"},
            {"code": "profile", "title": "个人中心", "subtitle": "查看设置和工资条"},
        ],
    }
