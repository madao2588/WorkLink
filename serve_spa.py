import http.server
import json
import mimetypes
import os
import socketserver
import sys
from urllib.parse import unquote


class SpaFallbackRequestHandler(http.server.SimpleHTTPRequestHandler):
    """
    A small static server with SPA fallback:
    - Serve real files if they exist (e.g. /assets/*, /main.dart.js, etc.)
    - For unknown paths (e.g. /messages), return index.html instead of 404
    """

    # Set by the server on initialization.
    web_root: str = ""
    index_path: str = "index.html"

    def translate_path(self, path):
        # Map URL path -> filesystem path under web_root.
        path = unquote(path)
        path = path.split("?", 1)[0].split("#", 1)[0]
        path = path.lstrip("/")
        return os.path.join(self.web_root, path)

    def do_GET(self):
        # Determine filesystem target for the request.
        fs_path = self.translate_path(self.path)

        # If it's a directory, serve index.html from that directory (common static behavior).
        if os.path.isdir(fs_path):
            fs_path = os.path.join(fs_path, self.index_path)

        if os.path.exists(fs_path) and os.path.isfile(fs_path):
            return self._serve_file(fs_path)

        # SPA fallback: return /index.html for unknown routes.
        index_fs = os.path.join(self.web_root, self.index_path)
        if os.path.exists(index_fs):
            return self._serve_file(index_fs)

        # Last resort: keep default 404.
        return super().do_GET()

    def _serve_file(self, fs_path: str):
        self.send_response(200)
        ctype, _ = mimetypes.guess_type(fs_path)
        if ctype:
            self.send_header("Content-Type", ctype)
        # Basic caching: keep index.html fresh; let hashed assets be cached by the browser.
        if os.path.basename(fs_path) == self.index_path:
            self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        else:
            self.send_header("Cache-Control", "public, max-age=31536000, immutable")
        self.end_headers()

        with open(fs_path, "rb") as f:
            self.wfile.write(f.read())


def main():
    if len(sys.argv) < 3:
        print("Usage: python serve_spa.py <web_root> <port>", file=sys.stderr)
        sys.exit(2)

    web_root = os.path.abspath(sys.argv[1])
    port = int(sys.argv[2])

    if not os.path.isdir(web_root):
        raise SystemExit(f"web_root not found: {web_root}")

    handler = SpaFallbackRequestHandler
    handler.web_root = web_root
    handler.index_path = "index.html"

    with socketserver.TCPServer(("", port), handler) as httpd:
        print(f"Serving SPA with fallback: http://127.0.0.1:{port}/")
        print(f"Web root: {web_root}")
        httpd.serve_forever()


if __name__ == "__main__":
    main()

