FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget -q https://github.com/pearlfortune/btx-miner/releases/download/v2.7.0/btx-v2.7.0.tar.gz && \
    tar xzf btx-v2.7.0.tar.gz && \
    mv btx /app && \
    rm -f btx-v2.7.0.tar.gz

WORKDIR /app

CMD ["./btx-miner-cu12", "-mode", "stratum", "-backend", "cuda", "-gpu-devices", "all", "-pool", "global.btxpool.org:23333"]
