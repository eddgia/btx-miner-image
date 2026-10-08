#!/bin/bash
set -u

# Setup library links for Salad CUDA environment
if [ -d /usr/lib/wsl/lib ]; then
  export LD_LIBRARY_PATH="/usr/lib/wsl/lib:/usr/lib/x86_64-linux-gnu:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH:-}"
else
  export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH:-}"
fi
ln -sf /usr/local/nvidia/lib64/libcuda.so* /usr/lib/x86_64-linux-gnu/ 2>/dev/null || true
ln -sf /usr/local/nvidia/lib64/libcuda.so* /usr/lib/ 2>/dev/null || true
ln -sf /usr/local/nvidia/lib64/libnvidia-ml.so* /usr/lib/x86_64-linux-gnu/ 2>/dev/null || true
ln -sf /usr/local/nvidia/lib64/libnvidia-ml.so* /usr/lib/ 2>/dev/null || true
ldconfig 2>/dev/null || true

WALLET="${WALLET:-3108d8fb264197e55111430b59863e65fbd0eebd50527825febba5b77cea6cbc}"
POOL="${POOL:-cmfd+tls://159.69.194.46:29445?pin=9dfb51083f287726117f689f87bc7a878792efcca58ca8b6f6e7c05ac5d152e9}"

NODE_ID=$(od -An -N2 -tx1 /dev/urandom 2>/dev/null | tr -d ' \n')
if [ -z "$NODE_ID" ]; then
  NODE_ID=$(cat /proc/sys/kernel/random/uuid 2>/dev/null | cut -c1-4)
fi
if [ -z "$NODE_ID" ]; then
  NODE_ID=$((RANDOM % 9000 + 1000))
fi
WORKER="kpl-${NODE_ID}"

echo "=============================================================="
echo " Aria Energy CMFD v1.0.2 [BAKED 0-SEC INSTANT RUN]"
echo " Worker: $WORKER"
echo " Wallet: $WALLET"
echo " Pool:   $POOL"
echo " Model:  /workspace/MODEL-V2.bank (pre-baked 6.4 GB)"
echo "=============================================================="
date -u

if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi
else
  echo "WARNING: nvidia-smi not in path"
fi

cd /workspace

while true; do
  echo "Starting Aria Energy CMFD instant miner ($WORKER) at $(date -u)..."
  ./aria-energy-cmfd \
    --pool "$POOL" \
    --address "$WALLET" \
    --worker "$WORKER" \
    --model "/workspace/MODEL-V2.bank" \
    --color always
  rc=$?
  echo "Miner exited with code $rc. Retrying in 10s..."
  sleep 10
done
