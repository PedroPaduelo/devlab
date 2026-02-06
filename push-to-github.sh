#!/bin/bash

# =============================================================================
# Script para subir o Dev Lab para o GitHub
# =============================================================================

set -e

echo "╔════════════════════════════════════════╗"
echo "║   📦 Push Dev Lab para GitHub      ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Verificar se git está configurado
if ! git config user.name > /dev/null 2>&1; then
    echo "⚙️  Configurando Git..."
    read -p "Seu nome: " git_name
    read -p "Seu email: " git_email

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    echo "✅ Git configurado!"
    echo ""
fi

# Verificar se já é um repo git
if [ ! -d ".git" ]; then
    echo "🔧 Inicializando repositório Git..."
    git init
    echo "✅ Git inicializado!"
    echo ""
fi

# Adicionar todos os arquivos
echo "📦 Adicionando arquivos..."
git add .
echo "✅ Arquivos adicionados!"
echo ""

# Commit
echo "💾 Fazendo commit..."
commit_msg="Dev Lab - Ambiente de desenvolvimento completo"
git commit -m "$commit_msg" 2>/dev/null || echo "ℹ️  Nada para commitar"
echo ""

# Configurar remote
echo "🔗 Configurando repositório remoto..."
echo ""
echo "📋 Passos:"
echo "1. Vá para: https://github.com/new"
echo "2. Crie um repositório chamado 'devlab' (ou outro nome)"
echo "3. Copie a URL do repositório"
echo ""
read -p "Cole a URL do repositório (ex: https://github.com/usuario/devlab.git): " repo_url

if [ -z "$repo_url" ]; then
    echo "❌ URL vazia! Abortando."
    exit 1
fi

# Verificar se já tem remote
if git remote | grep -q "origin"; then
    echo "⚠️  Remote 'origin' já existe. Removendo..."
    git remote remove origin
fi

git remote add origin "$repo_url"
echo "✅ Remote configurado!"
echo ""

# Renomear branch para main (se necessário)
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "🔄 Renomeando branch para 'main'..."
    git branch -M main
fi

# Push
echo "🚀 Enviando para GitHub..."
echo ""
git push -u origin main

echo ""
echo "╔════════════════════════════════════════╗"
echo "║        ✅ SUCESSO!                 ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "📁 Repositório: $repo_url"
echo ""
echo "🎯 Próximos passos:"
echo "1. Vá para o EasyPanel"
echo "2. Create Service → App → GitHub"
echo "3. Selecione o repositório 'devlab'"
echo "4. Configure as portas e volumes (veja EASYPANEL-GUIA-RAPIDO.md)"
echo "5. Deploy! 🚀"
echo ""
