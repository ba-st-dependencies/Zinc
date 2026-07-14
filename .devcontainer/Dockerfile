FROM mcr.microsoft.com/devcontainers/javascript-node:24-trixie

ARG TZ=UTC

# Install dependencies
# hadolint ignore=DL3008
RUN apt update \
  && apt install --yes --no-install-recommends \
    curl \
    gnupg \
    jq \
    lsb-release \
    shellcheck \
    tzdata \
    unzip \
    yamllint \
  # Configure Timezone
  && ln --symbolic --no-dereference --force /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/timezone \
  && rm --recursive --force /var/lib/apt/lists/*

USER node
WORKDIR /home/node

# Install markdownlint-cli for linting docs
RUN npm install --global markdownlint-cli@0.48.0

# Install Claude stable
RUN curl --fail --silent --show-error \
  --location https://claude.ai/install.sh --output /tmp/install-claude.sh \
  && bash /tmp/install-claude.sh stable \
  && rm /tmp/install-claude.sh

ENV PATH="/home/node/.claude/bin:${PATH}"
