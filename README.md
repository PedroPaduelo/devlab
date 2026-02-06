# 🚀 Dev Lab - Ambiente de Desenvolvimento Completo

> **Ambiente Docker pronto para desenvolvimento com VS Code (code-server), GitHub Copilot, Playwright, Node.js 22, e muito mais!**

---

## ✨ Features

- ✅ **VS Code no Browser** (code-server) - porta 8443
- ✅ **GitHub Copilot** pré-instalado e configurado
- ✅ **noVNC** - Desktop visual no browser (porta 6080)
- ✅ **Node.js 22.x LTS** + npm, yarn, pnpm
- ✅ **Playwright + Chromium** para automação web
- ✅ **Claude Code CLI** - IA da Anthropic
- ✅ **SSH** habilitado (porta 22)
- ✅ **Persistência automática** de extensões e configurações
- ✅ **Backup/Restore** integrado
- ✅ **Git, Python3, build-essential** e ferramentas essenciais

---

## 🚀 Quick Start

### Opção 1: Docker Compose (Recomendado)

```bash
# 1. Clone ou copie os arquivos
git clone seu-repo/devlab
cd devlab

# 2. Build e start
docker-compose up -d

# 3. Acessar VS Code
# URL: http://localhost:8443
# Senha: devlab123
```

### Opção 2: Docker Run

```bash
# Build
docker build -t devlab:latest .

# Run
docker run -d \
  --name devlab \
  -p 2222:22 \
  -p 6080:6080 \
  -p 8443:8443 \
  -v $(pwd)/workspace:/workspace \
  -v $(pwd)/vscode-extensions:/home/dev/.local/share/code-server \
  -v $(pwd)/vscode-config:/home/dev/.config/code-server \
  devlab:latest
```

### Opção 3: EasyPanel

Veja instruções detalhadas em: **[EASYPANEL-SETUP.md](EASYPANEL-SETUP.md)**

---

## 🔗 Acessos

Após iniciar o container:

| Serviço          | Porta | URL                    | Credenciais       |
|------------------|-------|------------------------|-------------------|
| **VS Code**      | 8443  | http://localhost:8443  | Senha: devlab123  |
| **noVNC**        | 6080  | http://localhost:6080  | Sem senha         |
| **SSH**          | 2222  | `ssh dev@localhost -p 2222` | dev/devlab123 |
| **App Node.js**  | 3000  | http://localhost:3000  | -                 |

---

## 🤖 GitHub Copilot

### ✅ Já está pré-instalado!

O GitHub Copilot e Copilot Chat já estão instalados no container. Você só precisa fazer login:

### Como fazer login:

1. Acesse o VS Code no browser (porta 8443)
2. Clique no ícone de **conta** no canto inferior esquerdo
3. Clique em **"Sign in to use GitHub Copilot"**
4. Siga o fluxo de autenticação do GitHub (OAuth)
5. Pronto! 🎉

### Verificar se está instalado:

```bash
# Via SSH no container
code-server --list-extensions | grep copilot
```

Deve retornar:
```
github.copilot
github.copilot-chat
```

---

## 💾 Persistência e Backup

### 🔄 Backup Automático

O container faz backup automático ao ser parado (SIGTERM).

### 📦 Backup Manual

```bash
# Via SSH no container ou docker exec
docker exec devlab /workspace/backup-restore.sh backup
```

### ♻️ Restore Manual

```bash
docker exec devlab /workspace/backup-restore.sh restore
```

### 🔧 Reinstalar Copilot

Se o Copilot sumir após restart:

```bash
docker exec devlab /workspace/backup-restore.sh install-copilot
```

### 📋 Listar Extensões

```bash
docker exec devlab /workspace/backup-restore.sh list
```

---

## 📂 Estrutura de Volumes

Configure estes volumes para **PERSISTÊNCIA COMPLETA**:

```yaml
volumes:
  # Seus projetos e código
  - ./workspace:/workspace

  # Extensões do VS Code (Copilot, etc)
  - ./vscode-extensions:/home/dev/.local/share/code-server

  # Configurações do code-server
  - ./vscode-config:/home/dev/.config/code-server

  # Configurações do Claude Code
  - ./claude-config:/home/dev/.claude

  # Pacotes npm globais
  - ./npm-global:/home/dev/.npm-global
```

---

## 🎨 Playwright - Automação Web

### Exemplo básico:

```bash
# SSH no container
ssh dev@localhost -p 2222

# Navegar para exemplos
cd ~/examples

# Rodar exemplo
node playwright-screenshot.js
```

### Ver o browser rodando:

Acesse o **noVNC** (porta 6080) e rode o Playwright com `headless: false` para ver o browser em ação!

### Criar seu próprio script:

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();

  await page.goto('https://github.com');
  await page.screenshot({
    path: '/workspace/screenshots/github.png',
    fullPage: true
  });

  console.log('✅ Screenshot salvo!');
  await browser.close();
})();
```

---

## 🛠️ Ferramentas Instaladas

### Node.js Ecosystem:
- Node.js 22.x LTS
- npm, yarn, pnpm
- TypeScript, ts-node
- nodemon, pm2

### AI/Automation:
- Claude Code CLI (`@anthropic-ai/claude-code`)
- Playwright + Chromium

### Dev Tools:
- Git
- Python 3
- build-essential (gcc, make, etc)
- vim, nano, htop, tree, jq

### VS Code Extensions (pré-instaladas):
- ✅ GitHub Copilot
- ✅ GitHub Copilot Chat
- ✅ Python
- ✅ ESLint
- ✅ Prettier
- ✅ GitLens

---

## ⚡ Comandos Úteis

### Aliases disponíveis no container:

```bash
# Git shortcuts
gs        # git status
ga        # git add
gc        # git commit
gp        # git push
gl        # git log --oneline --graph

# npm shortcuts
ni        # npm install
nr        # npm run
ns        # npm start
nt        # npm test

# VS Code
ext-list  # Listar extensões
ext-install # Instalar extensão

# Backup/Restore
backup    # Fazer backup
restore   # Restaurar backup
copilot-install # Reinstalar Copilot
```

---

## 🔧 Configurações

### Trocar senha do code-server:

#### Método 1 - Editar arquivo:
```bash
nano /home/dev/.config/code-server/config.yaml
# Altere a linha: password: sua-nova-senha
```

#### Método 2 - Variável de ambiente:
```yaml
# docker-compose.yml
environment:
  - PASSWORD=sua-senha-forte
```

### Trocar senha do usuário dev:

```bash
# Via SSH
passwd dev
```

### Configurar Git:

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

---

## 🐛 Troubleshooting

### Copilot não aparece após restart:

```bash
# Verificar se está instalado
docker exec devlab code-server --list-extensions | grep copilot

# Se não estiver, reinstalar
docker exec devlab /workspace/backup-restore.sh install-copilot

# Restart do container
docker restart devlab
```

### Extensões somem ao reiniciar:

**Causa:** Volume não configurado corretamente.

**Solução:**
1. Configure o volume: `./vscode-extensions:/home/dev/.local/share/code-server`
2. Faça backup: `docker exec devlab /workspace/backup-restore.sh backup`
3. Recrie o container com volumes corretos
4. Restore: `docker exec devlab /workspace/backup-restore.sh restore`

### Port forwarding duplicado no VS Code:

**Causa:** Auto-forward do VS Code Extension.

**Solução:** Já está configurado no `settings.json` para desabilitar auto-forward. Se persistir:

```bash
# Editar settings manualmente
docker exec -it devlab nano /home/dev/.local/share/code-server/User/settings.json
```

Adicionar:
```json
{
  "remote.autoForwardPorts": false
}
```

### Container não inicia:

1. Verificar logs:
   ```bash
   docker logs devlab
   ```

2. Verificar log de inicialização:
   ```bash
   docker exec devlab tail -f /var/log/devlab.log
   ```

3. Verificar recursos (CPU/RAM disponíveis)

---

## 📊 Monitoramento

### Ver logs em tempo real:

```bash
# Logs do Docker
docker logs -f devlab

# Logs de inicialização
docker exec devlab tail -f /var/log/devlab.log
```

### Status dos serviços:

```bash
docker exec devlab ps aux | grep -E "code-server|Xvfb|x11vnc|websockify|sshd"
```

### Recursos utilizados:

```bash
docker stats devlab
```

---

## 🔒 Segurança

### ⚠️ IMPORTANTE - Trocar senhas padrão:

```bash
# 1. Senha do usuário dev
docker exec -it devlab passwd dev

# 2. Senha do code-server
docker exec -it devlab nano /home/dev/.config/code-server/config.yaml

# 3. Restart do container
docker restart devlab
```

### Restringir acesso SSH (opcional):

```bash
# Usar autenticação por chave SSH ao invés de senha
# Editar /etc/ssh/sshd_config:
PasswordAuthentication no
PubkeyAuthentication yes
```

---

## 📁 Estrutura de Diretórios

```
/workspace/                    # Seus projetos (PERSISTENTE)
  ├── screenshots/             # Screenshots do Playwright
  ├── .vscode-backup/          # Backups automáticos
  ├── backup-restore.sh        # Script de backup/restore
  └── README.md                # Este arquivo

/home/dev/
  ├── .local/share/code-server/  # Extensões VS Code (PERSISTENTE)
  ├── .config/code-server/       # Configs code-server (PERSISTENTE)
  ├── .claude/                   # Configs Claude Code (PERSISTENTE)
  ├── .npm-global/               # npm packages globais
  └── examples/                  # Scripts de exemplo
```

---

## 🎯 Use Cases

### 1. Desenvolvimento Web Full-Stack:
- Frontend: React, Vue, Angular
- Backend: Node.js, Express, NestJS
- VS Code + Copilot para produtividade

### 2. Automação Web:
- Playwright para scraping, testes E2E
- noVNC para debugar visualmente
- Screenshots automáticos

### 3. Data Science / Python:
- Python 3 pré-instalado
- VS Code com extensão Python
- Jupyter notebooks (instale via pip)

### 4. DevOps / CI/CD:
- Git configurado
- SSH habilitado
- Docker-in-Docker (configure se necessário)

---

## 🤝 Contribuindo

Sinta-se livre para:
- Reportar bugs
- Sugerir features
- Fazer PRs
- Compartilhar seu setup

---

## 📜 License

MIT License - Use como quiser!

---

## 🆘 Suporte

Se precisar de ajuda:

1. **Verifique os logs**: `/var/log/devlab.log`
2. **Teste backup/restore**: `/workspace/backup-restore.sh`
3. **Reinicie o container**: `docker restart devlab`
4. **Recrie do zero** se necessário

---

## 🎉 Pronto para começar!

```bash
# Start
docker-compose up -d

# Acesse
http://localhost:8443

# Happy coding! 🚀
```

---

**Feito com ❤️ por Claude Code**
