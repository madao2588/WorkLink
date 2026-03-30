from datetime import UTC, date, datetime, timedelta

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.security import get_password_hash
from app.models.entities import (
    Approval,
    AttendanceRecord,
    Badge,
    Conversation,
    ConversationMember,
    Department,
    Message,
    Notification,
    SalarySlip,
    User,
    UserSetting,
)


def seed_database(db: Session) -> None:
    if db.scalar(select(User.id).limit(1)):
        return

    db.add(Department(id="dept-root", name="总部", parent_id=None, sort_no=0))
    db.commit()
    db.add_all(
        [
            Department(id="dept-rd", name="研发部", parent_id="dept-root", sort_no=1),
            Department(id="dept-hr", name="人事部", parent_id="dept-root", sort_no=2),
            Department(id="dept-fin", name="财务部", parent_id="dept-root", sort_no=3),
            Department(id="dept-mkt", name="市场部", parent_id="dept-root", sort_no=4),
        ]
    )
    db.commit()

    users = [
        User(
            id="u_me",
            login_id="zhangsan",
            password_hash=get_password_hash("123456"),
            name="张三",
            avatar="ZS",
            department_id="dept-rd",
            position="移动端工程师",
            employee_no="WL1001",
            email="zhangsan@worklink.local",
            mobile="13800000001",
            is_online=True,
        ),
        User(
            id="u_1",
            login_id="lisi",
            password_hash=get_password_hash("123456"),
            name="李四",
            avatar="LS",
            department_id="dept-mkt",
            position="市场专员",
            employee_no="WL1002",
            email="lisi@worklink.local",
            mobile="13800000002",
            is_online=False,
        ),
        User(
            id="u_2",
            login_id="wangwu",
            password_hash=get_password_hash("123456"),
            name="王五",
            avatar="WW",
            department_id="dept-hr",
            position="HRBP",
            employee_no="WL1003",
            email="wangwu@worklink.local",
            mobile="13800000003",
            is_online=True,
        ),
        User(
            id="u_3",
            login_id="zhaoliu",
            password_hash=get_password_hash("123456"),
            name="赵六",
            avatar="ZL",
            department_id="dept-fin",
            position="财务经理",
            employee_no="WL1004",
            email="zhaoliu@worklink.local",
            mobile="13800000004",
            is_online=True,
        ),
    ]
    db.add_all(users)
    db.commit()

    conversations = [
        Conversation(id="c_1", conversation_type="DIRECT"),
        Conversation(id="c_2", conversation_type="DIRECT"),
        Conversation(id="c_3", conversation_type="DIRECT"),
    ]
    db.add_all(conversations)
    db.commit()

    db.add_all(
        [
            ConversationMember(conversation_id="c_1", user_id="u_me", unread_count=1),
            ConversationMember(conversation_id="c_1", user_id="u_1", unread_count=0),
            ConversationMember(conversation_id="c_2", user_id="u_me", unread_count=2, is_pinned=True),
            ConversationMember(conversation_id="c_2", user_id="u_2", unread_count=0),
            ConversationMember(conversation_id="c_3", user_id="u_me", unread_count=0),
            ConversationMember(conversation_id="c_3", user_id="u_3", unread_count=0),
        ]
    )
    db.commit()

    now = datetime.now(UTC)
    db.add_all(
        [
            Message(id="m_1", conversation_id="c_1", sender_id="u_1", content="市场活动页的视觉稿我已经补完了，等你这边确认。", sent_at=now - timedelta(hours=5)),
            Message(id="m_2", conversation_id="c_1", sender_id="u_me", content="收到，我一会儿把最新需求整理给你。", sent_at=now - timedelta(hours=4, minutes=30)),
            Message(id="m_3", conversation_id="c_2", sender_id="u_2", content="你这周的请假流程我已经帮你预审过了。", sent_at=now - timedelta(hours=2)),
            Message(id="m_4", conversation_id="c_2", sender_id="u_2", content="有空的时候把出差时间范围补充一下就行。", sent_at=now - timedelta(minutes=42)),
            Message(id="m_5", conversation_id="c_3", sender_id="u_me", content="上月报销汇总表我已经重新上传了。", sent_at=now - timedelta(days=1, hours=1)),
            Message(id="m_6", conversation_id="c_3", sender_id="u_3", content="好的，我这边核对完再回你。", sent_at=now - timedelta(days=1, minutes=20)),
        ]
    )
    db.commit()

    db.add_all(
        [
            Approval(id="a_1", title="请假申请", applicant_id="u_me", start_time=now - timedelta(days=1), reason="家中有事，需要请假一天", status="PENDING", current_node_name="直属主管审批"),
            Approval(id="a_2", title="报销申请", applicant_id="u_me", start_time=now - timedelta(days=4), reason="客户差旅报销", status="APPROVED", current_node_name="审批完成"),
            Approval(id="a_3", title="采购申请", applicant_id="u_1", start_time=now - timedelta(days=2), reason="市场活动物料采购", status="REJECTED", current_node_name="财务复核"),
        ]
    )
    db.commit()

    db.add(
        AttendanceRecord(
            user_id="u_me",
            record_date=date.today(),
            check_in_time=now.replace(hour=8, minute=56, second=0, microsecond=0),
            status="CHECKED_IN",
            is_late=False,
        )
    )
    db.commit()

    db.add_all(
        [
            SalarySlip(id="s_2026_02", user_id="u_me", salary_month="2026-02", gross_amount=18800, net_amount=15260, status="ISSUED", issued_at=now - timedelta(days=20)),
            SalarySlip(id="s_2026_01", user_id="u_me", salary_month="2026-01", gross_amount=18400, net_amount=14980, status="ISSUED", issued_at=now - timedelta(days=50)),
        ]
    )
    db.commit()

    db.add_all(
        [
            Badge(id="b_1", user_id="u_me", name="高效协作", description="连续 30 天高效完成协作任务", icon="bolt", earned_at=now - timedelta(days=12)),
            Badge(id="b_2", user_id="u_me", name="全勤达人", description="月度全勤", icon="calendar", earned_at=now - timedelta(days=35)),
        ]
    )
    db.commit()

    db.add(UserSetting(user_id="u_me", notifications_enabled=True, sound_enabled=True, language="zh-CN", theme_mode="light"))
    db.commit()

    db.add_all(
        [
            Notification(id="n_1", user_id="u_me", title="审批提醒", content="你有 1 条待处理审批需要查看。", type="APPROVAL", biz_id="a_1", is_read=False),
            Notification(id="n_2", user_id="u_me", title="工资条已生成", content="2026 年 02 月工资条已生成，可前往我的页面查看。", type="PROFILE", biz_id="s_2026_02", is_read=True),
        ]
    )

    db.commit()
