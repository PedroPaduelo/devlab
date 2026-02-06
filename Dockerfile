# =============================================================================
# DEV LAB - com code-server (FUNCIONA!)
# Mantém code-server + adiciona suporte melhorado para extensões
# =============================================================================

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# Dependências base (mesmo do original)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget git ca-certificates gnupg lsb-release \
    build-essential python3 python3-pip \
    vim nano htop tree jq unzip zip rsync \
    openssh-server openssh-client iputils-ping net-tools \
    tzdata \
    xvfb x11vnc fluxbox xterm novnc websockify \
    libglib2.0-0 libnss3 libnspr4 libdbus-1-3 libatk1.0-0 \
    libatk-bridge2.0-0 libatspi2.0-0 libx11-6 libxcomposite1 \
    libxdamage1 libxext6 libxfixes3 libxrandr2 libgbm1 libdrm2 \
    libxcb1 libxkbcommon0 libasound2 libcups2 libpango-1.0-0 \
    libcairo2 fonts-liberation xdg-utils libx11-xcb1 libxcursor1 \
    libgtk-3-0 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf-2.0-0 \
    libwoff1 libvpx7 libevent-2.1-7 libopus0 libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 libharfbuzz-icu0 libenchant-2-2 \
    libsecret-1-0 libhyphen0 libmanette-0.2-0 libflite1 libgles2 \
    gstreamer1.0-libav gstreamer1.0-plugins-bad \
    fonts-noto-color-emoji fonts-freefont-ttf fonts-dejavu-core \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_PREFIX=/home/dev/.npm-global
ENV PATH="/home/dev/.npm-global/bin:$PATH"

# NPM global
RUN npm install -g \
    @anthropic-ai/claude-code yarn pnpm typescript ts-node nodemon pm2 playwright \
    && npm cache clean --force

# code-server (VOLTA PRO ORIGINAL)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Usuário dev
RUN groupadd -g 1000 dev \
    && useradd -m -u 1000 -g dev -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "dev:devlab123" | chpasswd

# SSH
RUN mkdir -p /var/run/sshd /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh \
    && chown dev:dev /home/dev/.ssh \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers dev" >> /etc/ssh/sshd_config

# Diretórios
RUN mkdir -p /workspace /workspace/screenshots /home/dev/.config/code-server \
    /home/dev/.local/share/code-server/extensions /home/dev/.local/share/code-server/User \
    && chown -R dev:dev /workspace /home/dev

# Playwright
USER dev
RUN npx playwright install chromium 2>/dev/null || true
USER root

# Config code-server
RUN printf 'bind-addr: 0.0.0.0:8443\nauth: password\npassword: devlab123\ncert: false\n' > /home/dev/.config/code-server/config.yaml

# Settings.json
RUN printf '{\n\
  "remote.autoForwardPorts": false,\n\
  "workbench.colorTheme": "Default Dark+"\n\
}\n' > /home/dev/.local/share/code-server/User/settings.json && \
    chown -R dev:dev /home/dev/.config /home/dev/.local

# Bash
RUN printf '\nexport PATH="/home/dev/.npm-global/bin:$PATH"\n\
echo "🚀 Dev Lab Ready! Use VS Code Desktop + Remote SSH para Copilot"\n' >> /home/dev/.bashrc

ENV DISPLAY=:99
ENV RESOLUTION=1920x1080x24

# Start script
RUN printf '#!/bin/bash\n\
set -e\n\
mkdir -p /var/run/sshd /home/dev/.config/code-server\n\
chown -R dev:dev /home/dev /workspace\n\
\n\
/usr/sbin/sshd\n\
sudo -u dev Xvfb :99 -screen 0 1920x1080x24 -ac &\n\
sudo -u dev DISPLAY=:99 fluxbox &\n\
sudo -u dev x11vnc -display :99 -forever -shared -rfbport 5900 -nopw &\n\
sudo -u dev websockify --web=/usr/share/novnc/ 6080 localhost:5900 &\n\
sudo -u dev code-server --bind-addr 0.0.0.0:8443 /workspace &\n\
\n\
echo "✅ PRONTO! SSH: 22 | VS Code: 8443 | noVNC: 6080"\n\
echo "🤖 Para Copilot: Use VS Code Desktop + Remote SSH"\n\
\n\
while true; do sleep 30; done\n' > /start.sh && chmod +x /start.sh

VOLUME ["/workspace", "/home/dev/.local/share/code-server", "/home/dev/.config/code-server"]
WORKDIR /workspace
EXPOSE 22 3000 6080 8443
CMD ["/start.sh"]
