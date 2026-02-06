# 🚀 GUIA RÁPIDO - EasyPanel

## 📋 Resumo: Como usar no EasyPanel

### Você tem 2 opções:

1. **GitHub** (recomendado) - EasyPanel faz o build automático
2. **Docker Hub** (mais rápido) - Você faz o build local

---

## ✅ OPÇÃO 1: Via GitHub (Recomendado)

### **1. Subir código para GitHub:**

```bash
# Já está no /workspace
git init
git add .
git commit -m "Dev Lab completo"

# Criar repo no GitHub (via web) depois:
git remote add origin https://github.com/SEU-USUARIO/devlab.git
git branch -M main
git push -u origin main
```

### **2. No EasyPanel:**

#### 2.1. Criar novo serviço:
```
Dashboard → Seu Projeto → "Create Service" → "App"
```

#### 2.2. Conectar GitHub:
```
Source Type: GitHub
→ Conectar conta GitHub
→ Selecionar repositório: devlab
→ Branch: main
```

#### 2.3. Build Config:
```
Dockerfile Path: /Dockerfile
Context Path: /
Build Command: (deixar vazio)
```

#### 2.4. Ports (Adicionar cada uma):

**Porta 8443 (VS Code):**
```
Container Port: 8443
Protocol: HTTP
Published: ✅ YES
Domain: vscode.SEU-DOMINIO.com (ou auto-gerado)
```

**Porta 6080 (noVNC/Desktop):**
```
Container Port: 6080
Protocol: HTTP
Published: ✅ YES
Domain: desktop.SEU-DOMINIO.com
```

**Porta 22 (SSH):**
```
Container Port: 22
Protocol: TCP
Published: ❌ NO (ou YES se quiser SSH público)
```

**Porta 3000 (Apps):**
```
Container Port: 3000
Protocol: HTTP
Published: ✅ YES
Domain: app.SEU-DOMINIO.com
```

#### 2.5. Volumes (MUITO IMPORTANTE!):

Clique em **"Add Mount"** 4 vezes:

**Mount 1 - Workspace:**
```
Container Path: /workspace
Volume: devlab-workspace (criar novo volume)
```

**Mount 2 - VS Code Extensions:**
```
Container Path: /home/dev/.local/share/code-server
Volume: devlab-extensions (criar novo volume)
```

**Mount 3 - VS Code Config:**
```
Container Path: /home/dev/.config/code-server
Volume: devlab-config (criar novo volume)
```

**Mount 4 - Claude Config:**
```
Container Path: /home/dev/.claude
Volume: devlab-claude (criar novo volume)
```

#### 2.6. Environment Variables (opcional):
```
TZ = America/Sao_Paulo
PASSWORD = minha-senha-forte
```

#### 2.7. Resources:

**⚠️ IMPORTANTE - TOTALMENTE LIVRE SEM LIMITES:**
```
Memory: (DEIXAR VAZIO - sem limite)
CPU: (DEIXAR VAZIO - sem limite)
Disk: (DEIXAR VAZIO - sem limite)
```

**NÃO coloque NENHUM valor!** Deixe todos os campos em branco para ter recursos ilimitados!

#### 2.8. Deploy:
```
Clique em "Deploy" e aguarde o build (5-10 min)
```

---

## ✅ OPÇÃO 2: Via Docker Hub (Mais Rápido)

### **1. Build local e push:**

```bash
# Build (demora ~5-10 min)
docker build -t SEU-USUARIO/devlab:latest .

# Login no Docker Hub
docker login

# Push
docker push SEU-USUARIO/devlab:latest
```

### **2. No EasyPanel:**

#### 2.1. Criar serviço:
```
Dashboard → "Create Service" → "App"
```

#### 2.2. Docker Image:
```
Source Type: Docker Image
Image: SEU-USUARIO/devlab:latest
```

#### 2.3. Configurar Ports e Volumes:
```
(Mesmo que a Opção 1 - passos 2.4, 2.5, 2.6, 2.7)
```

#### 2.4. Deploy:
```
Clique em "Deploy" (é mais rápido pois não faz build)
```

---

## 🔗 Após Deploy - Acessar:

### No EasyPanel, você verá os domínios gerados:

**VS Code (principal):**
```
https://vscode-seu-app.easypanel.host:8443
ou
https://vscode.seu-dominio.com (se configurou custom domain)
```

**noVNC (Desktop Visual):**
```
https://desktop-seu-app.easypanel.host:6080
```

**Senha padrão:**
```
devlab123
(TROQUE DEPOIS!)
```

---

## 🤖 Login no GitHub Copilot:

1. Acesse o VS Code via browser
2. Canto inferior esquerdo → ícone de **conta**
3. **"Sign in to use GitHub Copilot"**
4. Siga o OAuth do GitHub
5. Pronto! ✨

---

## 🔧 Comandos úteis no EasyPanel:

### Ver logs:
```
Service → Logs (no dashboard do EasyPanel)
```

### Abrir shell:
```
Service → Console/Terminal
```

### Restart:
```
Service → Actions → Restart
```

---

## 🛡️ SEGURANÇA - Trocar senhas:

### Via shell no EasyPanel:

```bash
# Abrir console do container
# Trocar senha do usuário dev:
passwd dev

# Trocar senha do VS Code:
nano /home/dev/.config/code-server/config.yaml
# Altere a linha: password: SUA-NOVA-SENHA
```

Ou defina via **Environment Variable** no EasyPanel:
```
PASSWORD=sua-senha-forte
```

---

## 🐛 Troubleshooting:

### 1. Build falha no EasyPanel:
```
- Verifique se o Dockerfile está na raiz do repo
- Verifique se o Context Path está correto: /
- Tente usar Docker Hub ao invés de build no EasyPanel
```

### 2. Copilot não aparece:
```bash
# Via console do container no EasyPanel:
/workspace/backup-restore.sh install-copilot

# Ou criar novo deploy
```

### 3. Volumes não persistem:
```
- Verifique se os Mounts estão configurados corretamente
- Use volumes nomeados (devlab-workspace, etc)
- Não use bind mounts no EasyPanel
```

### 4. Não consigo acessar as portas:
```
- Verifique se as portas estão marcadas como "Published"
- Verifique se o domínio foi gerado corretamente
- Aguarde alguns minutos após o deploy
```

### 5. Container reinicia constantemente:
```
- Verifique os logs no EasyPanel
- Pode ser falta de memória (aumente o limite)
- Verifique se as portas não estão em conflito
```

---

## 📊 Monitorar recursos:

No EasyPanel:
```
Service → Metrics
```

Ou via console:
```bash
htop
docker stats
```

---

## 💾 Backup manual:

```bash
# Via console do EasyPanel:
/workspace/backup-restore.sh backup

# Backup fica em: /workspace/.vscode-backup/
```

---

## 🎯 Resumo dos Comandos:

```bash
# Backup
/workspace/backup-restore.sh backup

# Restore
/workspace/backup-restore.sh restore

# Reinstalar Copilot
/workspace/backup-restore.sh install-copilot

# Listar extensões
/workspace/backup-restore.sh list
```

---

## 🚀 Pronto!

Agora é só:
1. ✅ Fazer deploy no EasyPanel
2. ✅ Acessar o VS Code
3. ✅ Fazer login no Copilot
4. ✅ Codar! 🎉

**Dúvidas?** Veja o [README.md](README.md) completo!
