#!/bin/bash
#
# 卸载 wbc_fsm systemd 自启动服务
# 用法: sudo ./uninstall_service.sh
#

set -e

UNIT_NAME="wbc_fsm.service"
SERVICE_FILE="/etc/systemd/system/${UNIT_NAME}"

if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 sudo 运行此脚本"
    exit 1
fi

echo "=== 卸载 wbc_fsm 自启动服务 ==="

if systemctl is-active --quiet "$UNIT_NAME"; then
    systemctl stop "$UNIT_NAME"
fi

if systemctl is-enabled --quiet "$UNIT_NAME"; then
    systemctl disable "$UNIT_NAME"
fi

rm -f "$SERVICE_FILE"

systemctl daemon-reload
systemctl reset-failed "$UNIT_NAME" || true

echo ""
echo "卸载完成。"
echo ""
echo "说明: 仅移除了 systemd 服务文件，仓库中的 scripts/wbc_fsm.service 保持不变。"