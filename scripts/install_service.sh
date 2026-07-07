#!/bin/bash
#
# 在机器人上执行一次，安装 systemd 自启动服务
# 用法: sudo ./install_service.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SERVICE_FILE="${SCRIPT_DIR}/wbc_fsm.service"
LAUNCH_SCRIPT="${SCRIPT_DIR}/wbc_fsm_launch.sh"

echo "=== 安装 wbc_fsm 自启动服务 ==="

chmod +x "$LAUNCH_SCRIPT"

cp "$SERVICE_FILE" /etc/systemd/system/wbc_fsm.service

systemctl daemon-reload
systemctl enable wbc_fsm.service

echo ""
echo "安装完成。"
echo ""
echo "常用命令:"
echo "  sudo systemctl start wbc_fsm     # 立即启动"
echo "  sudo systemctl stop wbc_fsm      # 停止"
echo "  sudo systemctl status wbc_fsm    # 查看状态"
echo "  sudo journalctl -u wbc_fsm -f    # 实时日志"
echo "  sudo systemctl disable wbc_fsm   # 取消自启动"
