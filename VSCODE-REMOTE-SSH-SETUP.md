# 🚀 VS Code Remote SSH + GitHub Copilot

## ✅ SSH funcionando na porta 2222

```bash
ssh -p 2222 dev@217.216.81.188
# Senha: devlab123
```

---

## 📝 Passo 1: Configurar Remote SSH no VS Code Desktop

### 1.1 Instalar extensão (se ainda não tiver):

No VS Code Desktop:
- `Ctrl+Shift+X` → Buscar **"Remote - SSH"**
- Instalar: `ms-vscode-remote.remote-ssh`

### 1.2 Adicionar host SSH:

1. **Abrir Command Palette**: `F1` ou `Ctrl+Shift+P`
2. Digite: **`Remote-SSH: Open SSH Configuration File`**
3. Escolha: `~/.ssh/config` (ou `C:\Users\SeuUsuario\.ssh\config` no Windows)
4. **Adicione:**

```
Host devlab
    HostName 217.216.81.188
    User dev
    Port 2222
```

5. **Salve o arquivo** (`Ctrl+S`)

### 1.3 Conectar:

1. **Command Palette**: `F1`
2. Digite: **`Remote-SSH: Connect to Host...`**
3. Escolha: **`devlab`**
4. Digite a senha: **`devlab123`**
5. Aguarde a conexão...

✅ **Pronto!** Agora você está conectado via Remote SSH! 🎉

---

## 📦 Passo 2: Instalar GitHub Copilot

**AGORA** que está conectado via Remote SSH, você pode instalar o Copilot:

### 2.1 No VS Code (já conectado remotamente):

1. **Extensions** (`Ctrl+Shift+X`)
2. Buscar: **`GitHub Copilot`**
3. Instalar: `GitHub.copilot`
4. Instalar também: **`GitHub Copilot Chat`** (`GitHub.copilot-chat`)

### 2.2 Login no GitHub:

1. Canto **inferior esquerdo** do VS Code → Ícone de **conta**
2. **"Sign in to use GitHub Copilot"**
3. Siga o fluxo OAuth do GitHub (abrirá no navegador)
4. Autorize o VS Code

### 2.3 Verificar se funcionou:

1. Abra um arquivo `.js` ou `.py`
2. Comece a digitar código
3. **Copilot deve sugerir** automaticamente! ✨
4. Pressione `Tab` para aceitar a sugestão

---

## 🎯 Comandos úteis no Remote SSH:

### Abrir pasta de trabalho:
```
File → Open Folder → /workspace
```

### Abrir terminal remoto:
```
Ctrl+` (ou View → Terminal)
```

### Instalar extensões no servidor remoto:
```
Extensions → Ícone de nuvem (Install in SSH: devlab)
```

---

## 🔐 Segurança: Trocar senha SSH

**IMPORTANTE:** A senha padrão é `devlab123`. Troque AGORA!

### Via terminal do VS Code (já conectado):

```bash
# Trocar senha do usuário dev
passwd

# Você vai digitar:
# 1. Senha atual: devlab123
# 2. Nova senha: (digite sua senha forte)
# 3. Confirmar nova senha
```

---

## 🐛 Troubleshooting

### 1. "Could not establish connection"
```bash
# Teste SSH manual primeiro:
ssh -p 2222 dev@217.216.81.188

# Se funcionar, reconfigure o VS Code
```

### 2. "Copilot not available"
```
- Verifique se está logado no GitHub
- Verifique se tem licença do Copilot ativa
- Recarregue a janela: Ctrl+Shift+P → "Reload Window"
```

### 3. "Extension is not available"
```
- Certifique-se de estar CONECTADO via Remote SSH
- Instale a extensão no servidor remoto (não local)
```

### 4. Conexão lenta/timeout
```
# Edite ~/.ssh/config e adicione:
Host devlab
    HostName 217.216.81.188
    User dev
    Port 2222
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

---

## 💡 Dicas

### 1. Terminal integrado:
Quando conectado via Remote SSH, o terminal do VS Code **já está no servidor**!
```bash
# Você já está em /workspace
pwd
# /workspace
```

### 2. Copilot Chat:
- `Ctrl+Shift+I` → Abre o Copilot Chat inline
- Ou clique no ícone de chat na barra lateral

### 3. Extensões recomendadas (instalar remotamente):
```
- GitHub.copilot
- GitHub.copilot-chat
- dbaeumer.vscode-eslint
- esbenp.prettier-vscode
- eamodio.gitlens
- ms-python.python
```

### 4. Salvar configuração SSH:
O arquivo `~/.ssh/config` fica salvo! Você pode conectar sempre com:
```
F1 → Remote-SSH: Connect to Host → devlab
```

---

## 🎉 Pronto!

Agora você tem:
- ✅ VS Code Desktop conectado via Remote SSH
- ✅ GitHub Copilot funcionando
- ✅ Terminal remoto no servidor
- ✅ Todas as extensões do VS Code real

**Bom código! 🚀**
