# ⚡ Quick Start - Dev Lab

## 🚀 Em 3 passos:

### 1️⃣ Build
```bash
docker build -t devlab:latest .
```

### 2️⃣ Start
```bash
docker-compose up -d
```

### 3️⃣ Acesse
```
VS Code: http://localhost:8443
Senha: devlab123
```

---

## 🎯 Ou use o Makefile:

```bash
make quickstart
```

Pronto! 🎉

---

## 🤖 GitHub Copilot

1. Abra o VS Code (http://localhost:8443)
2. Clique no ícone de **conta** (canto inferior esquerdo)
3. **"Sign in to use GitHub Copilot"**
4. Siga o OAuth do GitHub
5. Done! ✨

---

## 📦 No EasyPanel:

1. **Create App** → **Custom Docker Image**
2. **Image**: `devlab:latest` (ou seu registry)
3. **Portas**:
   - `8443` → VS Code
   - `6080` → noVNC
   - `22` → SSH
4. **Volumes** (IMPORTANTE!):
   ```
   /mnt/data/workspace → /workspace
   /mnt/data/vscode-ext → /home/dev/.local/share/code-server
   /mnt/data/vscode-cfg → /home/dev/.config/code-server
   ```
5. **Deploy!**

Mais detalhes: [EASYPANEL-SETUP.md](EASYPANEL-SETUP.md)

---

## 🆘 Problemas?

### Copilot não aparece:
```bash
docker exec devlab /workspace/backup-restore.sh install-copilot
docker restart devlab
```

### Extensões somem ao reiniciar:
```bash
# Verificar se volumes estão configurados
docker-compose down
# Editar docker-compose.yml - adicionar volumes
docker-compose up -d
```

### Port forwarding duplicado:
Já está configurado no `settings.json` - deve funcionar automaticamente.

---

## 💡 Comandos úteis (dentro do container):

```bash
# SSH no container
ssh dev@localhost -p 2222

# Ou via docker exec
docker exec -it devlab su - dev

# Backup
backup

# Restore
restore

# Reinstalar Copilot
copilot-install
```

---

## 📚 Documentação completa:

- [README.md](README.md) - Documentação completa
- [EASYPANEL-SETUP.md](EASYPANEL-SETUP.md) - Deploy no EasyPanel
- `make help` - Todos os comandos do Makefile

---

**Happy coding! 🚀✨**
