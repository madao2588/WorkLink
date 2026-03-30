from collections import defaultdict
from typing import Any

from fastapi import WebSocket


class ConnectionManager:
    def __init__(self) -> None:
        self._connections: dict[str, list[WebSocket]] = defaultdict(list)

    async def connect(self, user_id: str, websocket: WebSocket) -> None:
        await websocket.accept()
        self._connections[user_id].append(websocket)

    def disconnect(self, user_id: str, websocket: WebSocket) -> None:
        if user_id not in self._connections:
            return
        self._connections[user_id] = [conn for conn in self._connections[user_id] if conn != websocket]
        if not self._connections[user_id]:
            self._connections.pop(user_id, None)

    async def send_json(self, user_id: str, payload: dict[str, Any]) -> None:
        for websocket in self._connections.get(user_id, []):
            await websocket.send_json(payload)


connection_manager = ConnectionManager()
