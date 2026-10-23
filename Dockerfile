FROM kmyuhkyuk/aimilivpn-base-slim:latest

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DEPLOYMENT_MODE=docker \
    VPNGATE_DATA_DIR=/data \
    UI_HOST=0.0.0.0 \
    UI_PORT=8787 \
    LOCAL_PROXY_HOST=127.0.0.1 \
    LOCAL_PROXY_PORT=7928

WORKDIR /app

COPY VERSION README.md LICENSE ./
COPY vpngate_manager.py vpn_utils.py proxy_server.py snapshot_utils.py ./
COPY mirror ./mirror

RUN mkdir -p /data \
    && python3 -m py_compile vpngate_manager.py vpn_utils.py proxy_server.py snapshot_utils.py

VOLUME ["/data"]
EXPOSE 8787/tcp 7928/tcp
STOPSIGNAL SIGTERM

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD python3 -c "import os,socket; s=socket.create_connection(('127.0.0.1',int(os.environ.get('UI_PORT','8787'))),3); s.close()"

CMD ["python3", "vpngate_manager.py"]