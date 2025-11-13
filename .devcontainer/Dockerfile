# Development container for AcmUcDemo Phoenix application
ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=27.2.4
ARG DEBIAN_VERSION=bookworm-20251020-slim

FROM docker.io/hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}

# Install build dependencies and development tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  inotify-tools \
  postgresql-client \
  sudo \
  vim \
  wget \
  zsh \
  ca-certificates \
  gnupg \
  lsb-release \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs \
  && rm -rf /var/lib/apt/lists/*

# install claude code
RUN npm install -g @anthropic-ai/claude-code

# Install Docker CLI for Docker-in-Docker support
RUN install -m 0755 -d /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && chmod a+r /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y docker-ce-cli docker-compose-plugin \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME

# Install Hex and Rebar
RUN mix local.hex --force \
  && mix local.rebar --force

# Install Phoenix
RUN mix archive.install hex phx_new --force

# Install oh-my-zsh for better terminal experience
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set the default shell to zsh
ENV SHELL=/usr/bin/zsh

# Keep container running
CMD ["sleep", "infinity"]
