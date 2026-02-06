# 🚀 Configuração no EasyPanel

## 📦 Método 1: Via Docker Image (Recomendado)

### Passo 1: Build da imagem
Primeiro, faça o build da imagem localmente ou no registry:

```bash
docker build -t devlab:latest .
```

Ou publique no Docker Hub:
```bash
docker tag devlab:latest seu-usuario/devlab:latest
docker push seu-usuario/devlab:latest
```

### Passo 2: Criar App no EasyPanel

1. **No EasyPanel**, clique em **"Create App"**
2. Escolha **"Custom Docker Image"**
3. Configure:

#### ⚙️ Configurações Básicas:
- **Image**: `seu-usuario/devlab:latest` (ou path local)
- **Name**: `devlab`
- **Domain**: Configure seu domínio ou use o padrão do EasyPanel

#### 🔌 Portas (Ports):
Adicione estas portas:

| Container Port | Protocol | Tipo      | Nome         |
|----------------|----------|-----------|--------------|
| 8443           | HTTP     | Public    | vscode       |
| 6080           | HTTP     | Public    | novnc        |
| 22             | TCP      | Internal  | ssh          |
| 3000           | HTTP     | Public    | app-node     |

#### 💾 Volumes (Mounts):
**MUITO IMPORTANTE** - Adicione estes volumes para PERSISTÊNCIA:

| Host Path             | Container Path                             |
|-----------------------|--------------------------------------------|
| `/mnt/data/workspace` | `/workspace`                               |
| `/mnt/data/vscode-ext`| `/home/dev/.local/share/code-server`       |
| `/mnt/data/vscode-cfg`| `/home/dev/.config/code-server`            |
| `/mnt/data/claude`    | `/home/dev/.claude`                        |

#### 🌍 Environment Variables:
```
TZ=America/Sao_Paulo
RESOLUTION=1920x1080x24
```

#### ⚡ Resources:
- **CPU**: Deixar VAZIO (sem limites)
- **Memory**: Deixar VAZIO (sem limites)

**IMPORTANTE:** Não defina limites! Deixe todos os campos de recursos em branco para ter acesso LIVRE e ILIMITADO aos recursos do servidor.

---

## 📦 Método 2: Via GitHub/GitLab (CI/CD)

### Criar `.gitlab-ci.yml` ou GitHub Actions:

```yaml
# .gitlab-ci.yml exemplo
build:
  stage: build
  script:
    - docker build -t devlab:latest .
    - docker tag devlab:latest registry.example.com/devlab:latest
    - docker push registry.example.com/devlab:latest
```

---

## 🔗 Acessos no EasyPanel

Após deploy, configure os domínios no EasyPanel:

### 🖥️ VS Code (code-server)
- URL: `https://vscode.seu-dominio.com` (porta 8443)
- Senha: `devlab123`
- **IMPORTANTE**: Mude a senha editando o arquivo de config ou via variável de ambiente

### 🌐 noVNC (Desktop Visual)
- URL: `https://desktop.seu-dominio.com` (porta 6080)
- Use para ver o browser Chromium rodando

### 🔐 SSH
- Host: IP do servidor
- Porta: Configure no EasyPanel (ex: 2222)
- Usuário: `dev`
- Senha: `devlab123`

---

## 🛡️ SEGURANÇA - MUITO IMPORTANTE!

### ⚠️ Trocar senhas IMEDIATAMENTE após primeiro deploy:

#### 1. Trocar senha do usuário `dev`:
```bash
# Via SSH ou terminal do container
passwd dev
```

#### 2. Trocar senha do code-server:
```bash
# Editar o arquivo de configuração
nano /home/dev/.config/code-server/config.yaml

# Ou definir via variável de ambiente no EasyPanel:
PASSWORD=sua-senha-forte
```

#### 3. Configurar autenticação GitHub Copilot:
1. Acesse o VS Code via browser
2. Clique no ícone de conta (canto inferior esquerdo)
3. "Sign in to use GitHub Copilot"
4. Siga o fluxo de OAuth do GitHub

---

## 🔄 Persistência e Backups

### Backup automático ao parar o container:
O container faz backup automático ao receber SIGTERM.

### Backup manual:
```bash
# Via SSH no container
/workspace/backup-restore.sh backup
```

### Restore manual:
```bash
/workspace/backup-restore.sh restore
```

### Reinstalar Copilot:
```bash
/workspace/backup-restore.sh install-copilot
```

---

## 🐛 Troubleshooting no EasyPanel

### GitHub Copilot não aparece:
1. SSH no container
2. Execute: `/workspace/backup-restore.sh install-copilot`
3. Reinicie o code-server (ou container)

### Perda de extensões ao reiniciar:
- **Verifique se os volumes estão configurados corretamente**
- Volumes devem persistir em `/mnt/data/` ou path persistente do EasyPanel

### Port forwarding duplicado:
- Já configurado no `settings.json`
- Se persistir, edite manualmente:
  ```bash
  nano /home/dev/.local/share/code-server/User/settings.json
  ```

### Container não inicia:
1. Verifique logs no EasyPanel
2. Verifique permissões dos volumes
3. Verifique recursos (CPU/RAM) disponíveis

---

## 📊 Monitoramento

### Ver logs de inicialização:
```bash
tail -f /var/log/devlab.log
```

### Ver processos rodando:
```bash
htop
```

### Listar extensões instaladas:
```bash
code-server --list-extensions
```

---

## 🎯 Próximos Passos

1. ✅ Deploy no EasyPanel
2. ✅ Configurar volumes persistentes
3. ✅ Trocar senhas padrão
4. ✅ Fazer login no GitHub Copilot
5. ✅ Testar backup/restore
6. ✅ Configurar domínios personalizados
7. ✅ (Opcional) Configurar SSL/TLS via EasyPanel

---

## 💡 Dicas

- **Use o noVNC** (porta 6080) para ver o Playwright rodando visualmente
- **Alias úteis** já configurados: `backup`, `restore`, `copilot-install`
- **Git config**: Configure seu nome/email:
  ```bash
  git config --global user.name "Seu Nome"
  git config --global user.email "seu@email.com"
  ```
- **Claude Code**: Já instalado globalmente, use `claude-code` no terminal

---

## 🆘 Suporte

Se tiver problemas:
1. Verifique logs: `/var/log/devlab.log`
2. Teste backup/restore: `/workspace/backup-restore.sh`
3. Verifique permissões: `ls -la /workspace`
4. Reinicie o container no EasyPanel
