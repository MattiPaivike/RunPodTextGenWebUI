ARG CUDA_VERSION="12.4.1"
ARG UBUNTU_VERSION="22.04"
ARG DOCKER_FROM=nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}

FROM ${DOCKER_FROM} AS base

# ── Environment ────────────────────────────────────────────────────────────────
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

# ── Python 3.11.x & base tools ────────────────────────────────────────────────
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends software-properties-common curl tzdata && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        python3.11 python3.11-venv python3.11-distutils \
        openssh-server openssh-client git git-lfs && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 - && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    ln -sf /usr/local/bin/pip /usr/local/bin/pip3 && \
    python3 -m pip install --upgrade pip && \
    # remove distro packages that clash with pip upgrades
    apt-get purge -y python3-blinker || true && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/cuda/bin:${PATH}"
ENV PYTHONUNBUFFERED=1

COPY --chmod=755 start-ssh-only.sh /start.sh
WORKDIR /root

# ── text-generation-webui ─────────────────────────────────────────────────────
RUN git clone https://github.com/oobabooga/text-generation-webui && \
    cd text-generation-webui && \
    # checkout specific commit to avoid breaking changes
    git checkout 17f9c188bdb409740b51a4061ba527cf1345c4db && \
    pip3 install --break-system-packages torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu124 && \
    pip3 install --break-system-packages -r requirements/full/requirements.txt

COPY --chmod=755 scripts /root/scripts
COPY --chmod=755 start-with-ui.sh /start.sh

WORKDIR /workspace
ENTRYPOINT ["/start.sh"]
