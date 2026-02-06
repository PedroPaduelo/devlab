# Changelog - Dev Lab

## [1.0.0] - 2026-02-05

### ✨ Features Iniciais

#### Core:
- ✅ Ubuntu 22.04 base
- ✅ Node.js 22.x LTS
- ✅ Python 3
- ✅ Git, build-essential

#### VS Code / IDE:
- ✅ code-server (VS Code no browser)
- ✅ GitHub Copilot pré-instalado
- ✅ GitHub Copilot Chat pré-instalado
- ✅ Extensões úteis (Python, ESLint, Prettier, GitLens)
- ✅ Settings.json configurado (fix port forwarding)

#### Automação:
- ✅ Playwright + Chromium
- ✅ Claude Code CLI
- ✅ noVNC + Xvfb (desktop visual no browser)

#### Persistência:
- ✅ Sistema de backup/restore automático
- ✅ Volumes Docker configurados
- ✅ Backup automático ao parar container (SIGTERM)

#### Scripts:
- ✅ `/workspace/backup-restore.sh` - Backup/restore de configs
- ✅ `/start.sh` - Inicialização automática de serviços
- ✅ Bash aliases úteis pré-configurados

#### Documentação:
- ✅ README.md completo
- ✅ EASYPANEL-SETUP.md (deploy no EasyPanel)
- ✅ QUICKSTART.md (início rápido)
- ✅ Makefile (comandos úteis)
- ✅ .env.example (configurações)

#### Portas:
- `22` - SSH (dev/devlab123)
- `3000` - Apps Node.js
- `5000` - Apps Python/Flask
- `6080` - noVNC (desktop visual)
- `8443` - VS Code (code-server)

#### Segurança:
- ✅ Usuário não-root (dev)
- ✅ Sudo sem senha (desenvolvimento)
- ⚠️ Senhas padrão (devem ser trocadas!)

### 🐛 Bug Fixes

#### Port Forwarding Duplicado:
- **Problema**: VS Code Extension criava múltiplas portas auto-forwarded a cada reload
- **Solução**: Configurado `settings.json` com:
  ```json
  "remote.autoForwardPorts": false
  "remote.portsAttributes": { ... }
  ```

#### Perda de Extensões:
- **Problema**: Extensões sumiam ao reiniciar container
- **Solução**:
  - Volumes persistentes configurados
  - Sistema de backup/restore automático
  - Auto-restore ao detectar volume vazio

#### GitHub Copilot não instalava:
- **Problema**: Extensão não era instalada automaticamente
- **Solução**:
  - Pré-instalação no Dockerfile
  - Script de reinstalação disponível
  - Verificação automática no startup

### 📋 TODO / Roadmap

#### Próximas versões:
- [ ] Docker-in-Docker (DinD) opcional
- [ ] Jupyter Lab integrado
- [ ] Suporte a mais linguagens (Go, Rust, Java)
- [ ] Themes customizados para VS Code
- [ ] SSH com autenticação por chave (ao invés de senha)
- [ ] HTTPS/SSL automático (Let's Encrypt)
- [ ] Multi-user support
- [ ] Integração com ngrok (túnel público)
- [ ] Prometheus/Grafana para monitoring (opcional)

### 🎯 Compatibilidade

- ✅ Docker / Docker Compose
- ✅ EasyPanel
- ✅ Podman (não testado, deve funcionar)
- ✅ Kubernetes (requer adaptação)

### 📊 Performance

- **Build time**: ~5-10 min (primeira vez)
- **Start time**: ~10-15s
- **RAM**: 2-4 GB recomendado
- **CPU**: 2-4 cores recomendado
- **Disk**: ~2 GB (imagem) + volumes

### 🙏 Agradecimentos

- Equipe do **code-server** (VS Code no browser)
- **GitHub Copilot** (IA para código)
- **Playwright** (automação web)
- **Anthropic** (Claude Code CLI)
- Comunidade **EasyPanel**

---

## Versões anteriores

Primeira versão! 🎉
