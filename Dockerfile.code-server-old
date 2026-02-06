# =============================================================================
# DEV LAB - Ambiente de Desenvolvimento COMPLETO
# Autor: Claude Code
# =============================================================================
# ✅ Node.js 22.x + npm, Git, Claude Code CLI
# ✅ code-server (VS Code no browser) + GitHub Copilot PRÉ-INSTALADO
# ✅ noVNC + Xvfb (desktop visual remoto)
# ✅ Playwright + Chromium (automação + screenshots)
# ✅ PERSISTÊNCIA automática de extensões e configurações
# ✅ SSH habilitado
# =============================================================================

FROM ubuntu:22.04

# Evitar prompts interativos
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

# ============================================
# INSTALAR DEPENDÊNCIAS COMPLETAS
# ============================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essenciais
    curl wget git ca-certificates gnupg lsb-release \
    # Desenvolvimento
    build-essential python3 python3-pip \
    # Utilitários
    vim nano htop tree jq unzip zip rsync \
    # SSH e networking
    openssh-server openssh-client iputils-ping net-tools \
    # Timezone
    tzdata \
    # Desktop/VNC
    xvfb x11vnc fluxbox xterm novnc websockify \
    # Playwright/Browser dependencies (COMPLETO)
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
    # Sudo para usuário dev
    sudo \
    && rm -rf /var/lib/apt/lists/*

# ============================================
# INSTALAR NODE.JS 22.x LTS
# ============================================
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && node --version && npm --version

# Configurar npm global
ENV NPM_CONFIG_PREFIX=/home/dev/.npm-global
ENV PATH="/home/dev/.npm-global/bin:$PATH"

# ============================================
# INSTALAR FERRAMENTAS NPM GLOBAIS
# ============================================
RUN npm install -g \
    @anthropic-ai/claude-code \
    yarn pnpm typescript ts-node nodemon pm2 playwright \
    && npm cache clean --force

# ============================================
# INSTALAR CODE-SERVER (VS Code Web)
# ============================================
RUN curl -fsSL https://code-server.dev/install.sh | sh

# ============================================
# CRIAR USUÁRIO dev COM SUDO
# ============================================
RUN groupadd -g 1000 dev \
    && useradd -m -u 1000 -g dev -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && echo "dev:devlab123" | chpasswd

# Configurar SSH
RUN mkdir -p /var/run/sshd /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh \
    && chown dev:dev /home/dev/.ssh \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers dev" >> /etc/ssh/sshd_config

# ============================================
# CRIAR ESTRUTURA DE DIRETÓRIOS
# ============================================
RUN mkdir -p \
    /workspace \
    /workspace/screenshots \
    /workspace/.vscode-backup \
    /home/dev/.npm-global \
    /home/dev/.npm \
    /home/dev/.cache/ms-playwright \
    /home/dev/.claude \
    /home/dev/.config/code-server \
    /home/dev/.local/share/code-server/extensions \
    /home/dev/.local/share/code-server/User \
    && chown -R dev:dev /workspace \
    && chown -R dev:dev /home/dev

# ============================================
# INSTALAR PLAYWRIGHT BROWSERS (como dev)
# ============================================
USER dev
RUN npx playwright install chromium 2>/dev/null || true
USER root

# ============================================
# CONFIGURAR CODE-SERVER
# ============================================
RUN printf 'bind-addr: 0.0.0.0:8443\n\
auth: password\n\
password: devlab123\n\
cert: false\n\
' > /home/dev/.config/code-server/config.yaml \
    && chown -R dev:dev /home/dev/.config

# ============================================
# CONFIGURAR VS CODE SETTINGS (RESOLVER PROBLEMA DAS PORTAS!)
# ============================================
RUN printf '{\n\
  "workbench.colorTheme": "Default Dark+",\n\
  "editor.fontSize": 14,\n\
  "editor.tabSize": 2,\n\
  "editor.insertSpaces": true,\n\
  "files.autoSave": "afterDelay",\n\
  "files.autoSaveDelay": 1000,\n\
  "terminal.integrated.fontSize": 13,\n\
  "git.enableSmartCommit": true,\n\
  "git.confirmSync": false,\n\
  \n\
  "remote.autoForwardPorts": false,\n\
  "remote.autoForwardPortsSource": "output",\n\
  \n\
  "remote.portsAttributes": {\n\
    "8443": {\n\
      "label": "VS Code Server",\n\
      "onAutoForward": "ignore"\n\
    },\n\
    "6080": {\n\
      "label": "noVNC Desktop",\n\
      "onAutoForward": "ignore"\n\
    },\n\
    "5900": {\n\
      "label": "VNC Server",\n\
      "onAutoForward": "ignore"\n\
    },\n\
    "3000": {\n\
      "label": "App Node.js",\n\
      "onAutoForward": "notify"\n\
    }\n\
  },\n\
  \n\
  "github.copilot.enable": {\n\
    "*": true,\n\
    "yaml": true,\n\
    "plaintext": false,\n\
    "markdown": true\n\
  }\n\
}\n\
' > /home/dev/.local/share/code-server/User/settings.json \
    && chown dev:dev /home/dev/.local/share/code-server/User/settings.json

# ============================================
# PRÉ-INSTALAR EXTENSÕES DO VS CODE
# ============================================
USER dev

# GitHub Copilot (PRINCIPAL!)
RUN code-server --install-extension GitHub.copilot 2>/dev/null || true
RUN code-server --install-extension GitHub.copilot-chat 2>/dev/null || true

# Extensões úteis
RUN code-server --install-extension ms-python.python 2>/dev/null || true
RUN code-server --install-extension dbaeumer.vscode-eslint 2>/dev/null || true
RUN code-server --install-extension esbenp.prettier-vscode 2>/dev/null || true
RUN code-server --install-extension eamodio.gitlens 2>/dev/null || true

USER root

# ============================================
# CONFIGURAR BASH PROFILE
# ============================================
RUN printf '\n\
# Dev Lab Environment\n\
export PATH="/home/dev/.npm-global/bin:$PATH"\n\
export NPM_CONFIG_PREFIX="/home/dev/.npm-global"\n\
export EDITOR=nano\n\
export DISPLAY=:99\n\
\n\
# Aliases úteis\n\
alias ll="ls -lah"\n\
alias la="ls -A"\n\
alias l="ls -CF"\n\
alias ..="cd .."\n\
alias ...="cd ../.."\n\
\n\
# Git aliases\n\
alias gs="git status"\n\
alias ga="git add"\n\
alias gc="git commit"\n\
alias gp="git push"\n\
alias gl="git log --oneline --graph --decorate"\n\
alias gd="git diff"\n\
\n\
# Node/npm aliases\n\
alias ni="npm install"\n\
alias nr="npm run"\n\
alias ns="npm start"\n\
alias nt="npm test"\n\
alias nb="npm run build"\n\
\n\
# VS Code/Copilot\n\
alias code="code-server"\n\
alias ext-list="code-server --list-extensions"\n\
alias ext-install="code-server --install-extension"\n\
\n\
# Docker/Dev helpers\n\
alias backup="sudo /workspace/backup-restore.sh backup"\n\
alias restore="sudo /workspace/backup-restore.sh restore"\n\
alias copilot-install="sudo /workspace/backup-restore.sh install-copilot"\n\
\n\
# Prompt colorido com git branch\n\
parse_git_branch() {\n\
  git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \\(.*\\)/ (\\1)/"\n\
}\n\
PS1="\\[\\033[01;32m\\]\\u@devlab\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[33m\\]\\$(parse_git_branch)\\[\\033[00m\\]\\$ "\n\
\n\
echo "🚀 Dev Lab Environment - Ready!"\n\
echo "📍 Workspace: /workspace"\n\
echo "💡 Digite \\047ext-list\\047 para ver extensões instaladas"\n\
' >> /home/dev/.bashrc

RUN printf '\nsource ~/.bashrc\n' >> /home/dev/.profile

# ============================================
# VARIÁVEIS DE AMBIENTE
# ============================================
ENV DISPLAY=:99
ENV RESOLUTION=1920x1080x24

# ============================================
# CRIAR SCRIPT DE BACKUP/RESTORE
# ============================================
RUN printf '#!/bin/bash\n\
# Script de backup/restore de extensões e configurações\n\
\n\
BACKUP_DIR="/workspace/.vscode-backup"\n\
EXTENSIONS_DIR="/home/dev/.local/share/code-server/extensions"\n\
CONFIG_DIR="/home/dev/.config/code-server"\n\
USER_DIR="/home/dev/.local/share/code-server/User"\n\
\n\
log() { echo "[$(date +%%H:%%M:%%S)] $1"; }\n\
\n\
backup() {\n\
    log "📦 Fazendo backup..."\n\
    mkdir -p "$BACKUP_DIR"\n\
    \n\
    if [ -d "$EXTENSIONS_DIR" ]; then\n\
        log "  Extensões..."\n\
        rsync -a --delete "$EXTENSIONS_DIR/" "$BACKUP_DIR/extensions/" 2>/dev/null\n\
    fi\n\
    \n\
    if [ -d "$CONFIG_DIR" ]; then\n\
        log "  Configurações..."\n\
        rsync -a --delete "$CONFIG_DIR/" "$BACKUP_DIR/config/" 2>/dev/null\n\
    fi\n\
    \n\
    if [ -d "$USER_DIR" ]; then\n\
        log "  Settings do usuário..."\n\
        rsync -a --delete "$USER_DIR/" "$BACKUP_DIR/user/" 2>/dev/null\n\
    fi\n\
    \n\
    code-server --list-extensions > "$BACKUP_DIR/extensions-list.txt" 2>/dev/null || true\n\
    date > "$BACKUP_DIR/last-backup.txt"\n\
    \n\
    log "✅ Backup concluído: $BACKUP_DIR"\n\
}\n\
\n\
restore() {\n\
    if [ ! -d "$BACKUP_DIR" ]; then\n\
        log "❌ Backup não encontrado em $BACKUP_DIR"\n\
        return 1\n\
    fi\n\
    \n\
    log "🔄 Restaurando backup..."\n\
    \n\
    if [ -d "$BACKUP_DIR/extensions" ]; then\n\
        log "  Extensões..."\n\
        mkdir -p "$EXTENSIONS_DIR"\n\
        rsync -a --delete "$BACKUP_DIR/extensions/" "$EXTENSIONS_DIR/" 2>/dev/null\n\
        chown -R dev:dev "$EXTENSIONS_DIR"\n\
    fi\n\
    \n\
    if [ -d "$BACKUP_DIR/config" ]; then\n\
        log "  Configurações..."\n\
        mkdir -p "$CONFIG_DIR"\n\
        rsync -a --delete "$BACKUP_DIR/config/" "$CONFIG_DIR/" 2>/dev/null\n\
        chown -R dev:dev "$CONFIG_DIR"\n\
    fi\n\
    \n\
    if [ -d "$BACKUP_DIR/user" ]; then\n\
        log "  Settings do usuário..."\n\
        mkdir -p "$USER_DIR"\n\
        rsync -a --delete "$BACKUP_DIR/user/" "$USER_DIR/" 2>/dev/null\n\
        chown -R dev:dev "$USER_DIR"\n\
    fi\n\
    \n\
    log "✅ Restore concluído!"\n\
}\n\
\n\
install_copilot() {\n\
    log "🤖 Instalando GitHub Copilot..."\n\
    sudo -u dev code-server --install-extension GitHub.copilot --force\n\
    sudo -u dev code-server --install-extension GitHub.copilot-chat --force\n\
    log "✅ Copilot instalado! Reinicie o VS Code."\n\
}\n\
\n\
list_extensions() {\n\
    log "📋 Extensões instaladas:"\n\
    sudo -u dev code-server --list-extensions 2>/dev/null | while read ext; do\n\
        echo "  ✓ $ext"\n\
    done\n\
}\n\
\n\
case "$1" in\n\
    backup) backup ;;\n\
    restore) restore ;;\n\
    install-copilot) install_copilot ;;\n\
    list) list_extensions ;;\n\
    *)\n\
        echo "Uso: $0 {backup|restore|install-copilot|list}"\n\
        echo ""\n\
        echo "  backup          - Backup de extensões e configs"\n\
        echo "  restore         - Restore do backup"\n\
        echo "  install-copilot - Instala GitHub Copilot"\n\
        echo "  list            - Lista extensões instaladas"\n\
        exit 1\n\
        ;;\n\
esac\n\
' > /workspace/backup-restore.sh && chmod +x /workspace/backup-restore.sh

# ============================================
# CRIAR SCRIPT DE INICIALIZAÇÃO
# ============================================
RUN printf '#!/bin/bash\n\
set -e\n\
\n\
LOG="/var/log/devlab.log"\n\
exec 1> >(tee -a "$LOG") 2>&1\n\
\n\
log() { echo "[$(date +%%Y-%%m-%%d\\ %%H:%%M:%%S)] $1"; }\n\
\n\
cleanup() {\n\
    log "🛑 Parando serviços..."\n\
    /workspace/backup-restore.sh backup 2>/dev/null || true\n\
    pkill -f "code-server" 2>/dev/null || true\n\
    pkill -f "websockify" 2>/dev/null || true\n\
    pkill -f "x11vnc" 2>/dev/null || true\n\
    pkill -f "fluxbox" 2>/dev/null || true\n\
    pkill -f "Xvfb" 2>/dev/null || true\n\
    exit 0\n\
}\n\
\n\
trap cleanup SIGTERM SIGINT\n\
\n\
log ""\n\
log "╔════════════════════════════════════════╗"\n\
log "║   🚀 DEV LAB ENVIRONMENT STARTUP   ║"\n\
log "╚════════════════════════════════════════╝"\n\
log ""\n\
\n\
# Criar diretórios\n\
mkdir -p /var/run/sshd \\\n\
  /home/dev/.config/code-server \\\n\
  /home/dev/.local/share/code-server/extensions \\\n\
  /home/dev/.local/share/code-server/User \\\n\
  /workspace/screenshots \\\n\
  /workspace/.vscode-backup\n\
\n\
# Permissões\n\
chown -R dev:dev /home/dev/.config 2>/dev/null || true\n\
chown -R dev:dev /home/dev/.local 2>/dev/null || true\n\
chown -R dev:dev /workspace 2>/dev/null || true\n\
\n\
# Auto-restore se volume está vazio\n\
if [ -d "/workspace/.vscode-backup/extensions" ] && [ -z "$(ls -A /home/dev/.local/share/code-server/extensions 2>/dev/null)" ]; then\n\
    log "📦 Volume vazio detectado, restaurando backup..."\n\
    /workspace/backup-restore.sh restore 2>/dev/null || true\n\
fi\n\
\n\
# Verificar Copilot\n\
if ! sudo -u dev code-server --list-extensions 2>/dev/null | grep -q "github.copilot"; then\n\
    log "⚠️  GitHub Copilot não encontrado, instalando..."\n\
    /workspace/backup-restore.sh install-copilot 2>/dev/null || true\n\
fi\n\
\n\
# SSH\n\
log "🔐 Iniciando SSH..."\n\
pgrep -x sshd > /dev/null || /usr/sbin/sshd -E /var/log/sshd.log\n\
sleep 1\n\
pgrep -x sshd > /dev/null && log "  ✅ SSH (porta 22)" || log "  ❌ SSH falhou"\n\
\n\
# Xvfb\n\
log "🖥️  Iniciando Xvfb..."\n\
if ! pgrep -x Xvfb > /dev/null; then\n\
    sudo -u dev Xvfb :99 -screen 0 ${RESOLUTION:-1920x1080x24} -ac +extension GLX +render -noreset &\n\
    sleep 2\n\
fi\n\
export DISPLAY=:99\n\
pgrep -x Xvfb > /dev/null && log "  ✅ Xvfb (display :99)" || log "  ❌ Xvfb falhou"\n\
\n\
# Fluxbox\n\
log "🪟 Iniciando Fluxbox..."\n\
if ! pgrep -x fluxbox > /dev/null; then\n\
    sudo -u dev DISPLAY=:99 fluxbox &\n\
    sleep 1\n\
fi\n\
pgrep -x fluxbox > /dev/null && log "  ✅ Fluxbox" || log "  ❌ Fluxbox falhou"\n\
\n\
# x11vnc\n\
log "📡 Iniciando x11vnc..."\n\
if ! pgrep -x x11vnc > /dev/null; then\n\
    sudo -u dev x11vnc -display :99 -forever -shared -rfbport 5900 -nopw -xkb &\n\
    sleep 1\n\
fi\n\
pgrep -x x11vnc > /dev/null && log "  ✅ x11vnc (porta 5900)" || log "  ❌ x11vnc falhou"\n\
\n\
# noVNC\n\
log "🌐 Iniciando noVNC..."\n\
if ! pgrep -f "websockify.*6080" > /dev/null; then\n\
    sudo -u dev websockify --web=/usr/share/novnc/ 6080 localhost:5900 &\n\
    sleep 1\n\
fi\n\
pgrep -f "websockify.*6080" > /dev/null && log "  ✅ noVNC (porta 6080)" || log "  ❌ noVNC falhou"\n\
\n\
# code-server\n\
log "💻 Iniciando code-server..."\n\
if ! pgrep -f "code-server" > /dev/null; then\n\
    sudo -u dev code-server --bind-addr 0.0.0.0:8443 /workspace &\n\
    sleep 3\n\
fi\n\
pgrep -f "code-server" > /dev/null && log "  ✅ code-server (porta 8443)" || log "  ❌ code-server falhou"\n\
\n\
# Listar extensões\n\
log ""\n\
log "📦 Extensões VS Code instaladas:"\n\
sudo -u dev code-server --list-extensions 2>/dev/null | while read ext; do\n\
    log "   • $ext"\n\
done || log "   (nenhuma extensão encontrada)"\n\
\n\
log ""\n\
log "╔════════════════════════════════════════╗"\n\
log "║        ✅ AMBIENTE PRONTO!         ║"\n\
log "╚════════════════════════════════════════╝"\n\
log ""\n\
log "🔗 Acesso:"\n\
log "   • SSH:     porta 22   (dev/devlab123)"\n\
log "   • VS Code: porta 8443 (senha: devlab123)"\n\
log "   • noVNC:   porta 6080 (desktop visual)"\n\
log ""\n\
log "📁 Workspace: /workspace"\n\
log "🤖 GitHub Copilot: Faça login no VS Code"\n\
log ""\n\
log "💾 Comandos úteis:"\n\
log "   • backup  - Salvar extensões/configs"\n\
log "   • restore - Restaurar backup"\n\
log "   • copilot-install - Reinstalar Copilot"\n\
log ""\n\
\n\
# Manter container ativo\n\
while true; do\n\
    wait -n 2>/dev/null || sleep 30\n\
done\n\
' > /start.sh && chmod +x /start.sh

# ============================================
# CRIAR EXEMPLO PLAYWRIGHT
# ============================================
RUN mkdir -p /home/dev/examples && \
    printf 'const { chromium } = require("playwright");\n\
\n\
(async () => {\n\
  console.log("🚀 Iniciando Playwright...");\n\
  \n\
  const browser = await chromium.launch({\n\
    headless: false, // true para sem visualização\n\
  });\n\
  \n\
  const page = await browser.newPage();\n\
  await page.goto("https://github.com");\n\
  \n\
  await page.screenshot({ \n\
    path: "/workspace/screenshots/github.png",\n\
    fullPage: true \n\
  });\n\
  \n\
  console.log("✅ Screenshot salvo: /workspace/screenshots/github.png");\n\
  \n\
  await browser.close();\n\
})();\n\
' > /home/dev/examples/playwright-screenshot.js && \
    chown -R dev:dev /home/dev/examples

# ============================================
# VOLUMES PARA PERSISTÊNCIA
# ============================================
VOLUME ["/workspace", "/home/dev/.local/share/code-server", "/home/dev/.config/code-server", "/home/dev/.claude"]

WORKDIR /workspace

EXPOSE 22 3000 5000 6080 8080 8443

USER root

CMD ["/start.sh"]
