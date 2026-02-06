# 🔧 Como conectar via SSH no EasyPanel

## ⚠️ Problema: PermissionDenied ao conectar

**Causa**: A porta SSH (22) não está exposta publicamente no EasyPanel.

---

## ✅ Solução 1: Publicar porta SSH (Recomendado)

### No EasyPanel:

1. **Vá para seu serviço devlab**
2. **Clique em "Domains" ou "Ports"**
3. **Encontre a porta 22 (SSH)**
4. **Configure assim:**

```
Container Port: 22
Protocol: TCP
Published: ✅ YES (marcar como publicado)
External Port: (vai gerar automático, ex: 32222)
```

5. **Clique em "Save" e aguarde o deploy**

### Depois, conecte usando a porta externa:

```bash
# Anote a porta externa que o EasyPanel gerou (ex: 32222)
ssh -p 32222 dev@217.216.81.188
```

**No VS Code Remote SSH:**
```
Host devlab
  HostName 217.216.81.188
  User dev
  Port 32222  ← use a porta externa do EasyPanel
```

---

## ✅ Solução 2: Usar Console do EasyPanel (Mais Rápido)

Se você não quer expor SSH publicamente:

### 1. No EasyPanel:
```
Seu serviço → Console/Terminal (ou "Exec")
```

Isso abre um terminal **direto no container**, sem precisar de SSH!

### 2. Instalar GitHub Copilot via console:

Uma vez dentro do console do EasyPanel:

```bash
# Instalar extensão do Copilot
code-server --install-extension GitHub.copilot

# Verificar se instalou
code-server --list-extensions | grep copilot
```

**MAS ATENÇÃO:** GitHub Copilot **não funciona no code-server** (navegador). Só funciona no **VS Code Desktop**.

---

## ✅ Solução 3: Port Forwarding via noVNC + VS Code Desktop Local

Alternativa sem expor SSH:

### 1. Acesse o noVNC (Desktop Visual):
```
https://desktop.seu-dominio.com:6080
```

### 2. Dentro do noVNC, abra o terminal e inicie SSH local:
```bash
# SSH já está rodando localmente no container
# Você pode usar VS Code Desktop instalado no próprio noVNC!
```

### 3. Instale VS Code Desktop dentro do container:
```bash
# Via terminal do noVNC
wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo dpkg -i vscode.deb
sudo apt-get install -f -y

# Executar VS Code
code
```

Agora você tem VS Code **verdadeiro** rodando dentro do noVNC, e pode instalar Copilot normalmente!

---

## 🎯 Recomendação Final

**Melhor opção depende do seu uso:**

| Opção | Vantagens | Desvantagens |
|-------|-----------|--------------|
| **Publicar SSH** | Acesso remoto de qualquer lugar | Precisa expor porta públicamente |
| **Console EasyPanel** | Rápido, direto, seguro | Só acessa dentro do EasyPanel |
| **VS Code no noVNC** | Copilot funciona nativo | Performance menor (via browser) |

---

## 🔐 Segurança

Se escolher expor SSH publicamente:

1. **Mude a senha IMEDIATAMENTE:**
```bash
passwd dev
```

2. **Configure autenticação por chave SSH:**
```bash
# No seu PC local
ssh-keygen -t ed25519

# Copie a chave para o servidor
ssh-copy-id -p 32222 dev@217.216.81.188

# Desabilite senha no servidor
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no
sudo systemctl restart ssh
```

---

## 📝 Resumo

Para conectar **VS Code Desktop com GitHub Copilot**:

1. ✅ **Via SSH público**: Publicar porta 22 no EasyPanel
2. ✅ **Via noVNC**: Instalar VS Code Desktop dentro do container
3. ❌ **Via code-server**: Não suporta GitHub Copilot

Escolha a opção que preferir! 🚀
