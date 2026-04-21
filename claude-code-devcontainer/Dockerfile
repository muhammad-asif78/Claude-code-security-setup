FROM ghcr.io/astral-sh/uv:0.10 AS uv
FROM mcr.microsoft.com/devcontainers/base:ubuntu24.04

ARG TZ=UTC
ENV TZ="$TZ"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  bubblewrap \
  ca-certificates \
  curl \
  fd-find \
  fzf \
  git \
  jq \
  nano \
  ripgrep \
  tmux \
  unzip \
  vim \
  zsh \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=uv /uv /usr/local/bin/uv

RUN mkdir -p /workspace /commandhistory /home/vscode/.claude /opt && \
  touch /commandhistory/.zsh_history && \
  chown -R vscode:vscode /workspace /commandhistory /home/vscode/.claude /opt

ENV DEVCONTAINER=true
ENV SHELL=/bin/zsh
ENV EDITOR=nano
ENV VISUAL=nano

WORKDIR /workspace
USER vscode

ENV PATH="/home/vscode/.local/bin:$PATH"

COPY --chown=vscode:vscode .zshrc /home/vscode/.zshrc.custom
RUN printf '\nsource ~/.zshrc.custom\n' >> /home/vscode/.zshrc

COPY --chown=vscode:vscode post_install.py /opt/post_install.py
