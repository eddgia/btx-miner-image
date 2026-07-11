FROM nvidia/cuda:12.6.3-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget -q https://github.com/pearlfortune/btx-miner/releases/download/v2.9.3/btx-v2.9.3.tar.gz && \
    tar xzf btx-v2.9.3.tar.gz && \
    mv btx /app && \
    rm -f btx-v2.9.3.tar.gz

WORKDIR /app

CMD ["sh", "-c", "CUDA_VER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null | head -1 | cut -d. -f1); if [ \"$CUDA_VER\" -ge 13 ] 2>/dev/null; then exec ./btx-miner-cu13; else exec ./btx-miner-cu12; fi"]
