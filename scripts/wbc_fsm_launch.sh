#!/bin/bash
#
# wbc_fsm 机器人端启动脚本
# 部署路径: /home/unitree/wbc_fsm/scripts/wbc_fsm_launch.sh
#
# 用法:
#   sudo ./wbc_fsm_launch.sh          # 手动启动
#   sudo ./wbc_fsm_launch.sh --check  # 仅检查环境，不启动
#

set -e

# ============ 按机器人实际路径改这里 ============
PROJECT_DIR="/home/unitree/wbc_fsm"
ONNX_DIR="${PROJECT_DIR}/onnxruntime-linux-x64-1.22.0"
UNITREE_SDK_DIR="/opt/unitree_robotics"
# ==============================================

BIN="${PROJECT_DIR}/build/wbc_fsm"

log()  { echo "[$(date '+%H:%M:%S')] $*"; }
err()  { echo "[$(date '+%H:%M:%S')] [ERROR] $*" >&2; }

check_env() {
    local ok=true

    if [ "$(id -u)" -ne 0 ]; then
        err "需要 root 权限 (实时调度 SCHED_FIFO)"
        ok=false
    fi

    if [ ! -f "$BIN" ]; then
        err "找不到 $BIN"
        err "  请先在机器人上编译: cd ${PROJECT_DIR}/build && cmake .. && make -j"
        ok=false
    fi

    if ! ip link show eth0 > /dev/null 2>&1; then
        err "eth0 未检测到，请检查网线是否连接到机器人"
        ok=false
    fi

    $ok
}

[[ "$1" == "--check" ]] && check_env && log "环境检查通过" && exit 0

check_env

# ---- 等待 eth0 就绪 ----
for i in $(seq 1 15); do
    ip link show eth0 > /dev/null 2>&1 && break
    log "等待 eth0... (${i}/15)"
    sleep 2
done

# ---- 库路径 ----
export LD_LIBRARY_PATH="${ONNX_DIR}/lib:${UNITREE_SDK_DIR}/lib:${LD_LIBRARY_PATH}"

# ---- 启动 ----
log "启动 wbc_fsm ..."
cd "$PROJECT_DIR"
exec "$BIN"
