# =============================================================================
# Dev Lab - Makefile
# =============================================================================
# Comandos rápidos para gerenciar o ambiente de desenvolvimento

.PHONY: help build up down restart logs shell backup restore install-copilot clean

# Variáveis
CONTAINER_NAME=devlab
IMAGE_NAME=devlab:latest

# Comando padrão
help:
	@echo "╔════════════════════════════════════════╗"
	@echo "║       Dev Lab - Comandos Úteis      ║"
	@echo "╚════════════════════════════════════════╝"
	@echo ""
	@echo "🚀 Inicialização:"
	@echo "  make build          - Build da imagem Docker"
	@echo "  make up             - Iniciar container"
	@echo "  make down           - Parar container"
	@echo "  make restart        - Reiniciar container"
	@echo ""
	@echo "📊 Monitoramento:"
	@echo "  make logs           - Ver logs em tempo real"
	@echo "  make logs-startup   - Ver logs de inicialização"
	@echo "  make status         - Status dos serviços"
	@echo "  make stats          - Estatísticas de recursos"
	@echo ""
	@echo "🔧 Manutenção:"
	@echo "  make shell          - Abrir shell no container"
	@echo "  make backup         - Fazer backup das configs"
	@echo "  make restore        - Restaurar backup"
	@echo "  make install-copilot - Reinstalar GitHub Copilot"
	@echo "  make extensions     - Listar extensões instaladas"
	@echo ""
	@echo "🧹 Limpeza:"
	@echo "  make clean          - Parar e remover container"
	@echo "  make clean-all      - Remover container e imagem"
	@echo "  make prune          - Limpar volumes órfãos"
	@echo ""
	@echo "🔗 Acesso:"
	@echo "  VS Code:  http://localhost:8443  (senha: devlab123)"
	@echo "  noVNC:    http://localhost:6080"
	@echo "  SSH:      ssh dev@localhost -p 2222"
	@echo ""

# Build da imagem
build:
	@echo "🔨 Building Docker image..."
	docker build -t $(IMAGE_NAME) .
	@echo "✅ Build concluído!"

# Iniciar container
up:
	@echo "🚀 Iniciando container..."
	docker-compose up -d
	@echo "✅ Container iniciado!"
	@echo ""
	@echo "🔗 Acessos:"
	@echo "  VS Code:  http://localhost:8443"
	@echo "  noVNC:    http://localhost:6080"
	@echo "  SSH:      ssh dev@localhost -p 2222"

# Parar container
down:
	@echo "🛑 Parando container..."
	docker-compose down
	@echo "✅ Container parado!"

# Reiniciar container
restart:
	@echo "🔄 Reiniciando container..."
	docker-compose restart
	@echo "✅ Container reiniciado!"

# Ver logs
logs:
	@echo "📋 Logs do container (Ctrl+C para sair):"
	docker-compose logs -f

# Ver logs de inicialização
logs-startup:
	@echo "📋 Logs de inicialização:"
	docker exec $(CONTAINER_NAME) cat /var/log/devlab.log

# Status dos serviços
status:
	@echo "📊 Status dos serviços:"
	@docker exec $(CONTAINER_NAME) ps aux | grep -E "code-server|Xvfb|x11vnc|websockify|sshd" | grep -v grep || echo "Container não está rodando"

# Estatísticas de recursos
stats:
	@echo "📈 Estatísticas de recursos:"
	docker stats $(CONTAINER_NAME) --no-stream

# Abrir shell no container
shell:
	@echo "🐚 Abrindo shell no container..."
	docker exec -it $(CONTAINER_NAME) su - dev

# Shell como root
shell-root:
	@echo "🐚 Abrindo shell como root..."
	docker exec -it $(CONTAINER_NAME) bash

# Backup
backup:
	@echo "💾 Fazendo backup..."
	docker exec $(CONTAINER_NAME) /workspace/backup-restore.sh backup
	@echo "✅ Backup concluído!"

# Restore
restore:
	@echo "♻️ Restaurando backup..."
	docker exec $(CONTAINER_NAME) /workspace/backup-restore.sh restore
	@echo "✅ Restore concluído!"

# Instalar Copilot
install-copilot:
	@echo "🤖 Instalando GitHub Copilot..."
	docker exec $(CONTAINER_NAME) /workspace/backup-restore.sh install-copilot
	@echo "✅ Copilot instalado! Reinicie o VS Code."

# Listar extensões
extensions:
	@echo "📦 Extensões instaladas:"
	@docker exec $(CONTAINER_NAME) /workspace/backup-restore.sh list

# Limpar container
clean:
	@echo "🧹 Removendo container..."
	docker-compose down
	docker rm -f $(CONTAINER_NAME) 2>/dev/null || true
	@echo "✅ Container removido!"

# Limpar tudo (container + imagem)
clean-all: clean
	@echo "🧹 Removendo imagem..."
	docker rmi $(IMAGE_NAME) 2>/dev/null || true
	@echo "✅ Imagem removida!"

# Limpar volumes órfãos
prune:
	@echo "🧹 Limpando volumes órfãos..."
	docker volume prune -f
	@echo "✅ Limpeza concluída!"

# Rebuild completo
rebuild: clean build up
	@echo "✅ Rebuild completo concluído!"

# Verificar saúde do container
health:
	@echo "🏥 Verificando saúde do container..."
	@docker inspect --format='{{.State.Health.Status}}' $(CONTAINER_NAME) 2>/dev/null || echo "Container não está rodando ou sem healthcheck"

# Criar .env a partir do exemplo
env:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ Arquivo .env criado! Edite conforme necessário."; \
	else \
		echo "⚠️  Arquivo .env já existe!"; \
	fi

# Quick start (tudo de uma vez)
quickstart: env build up
	@echo ""
	@echo "╔════════════════════════════════════════╗"
	@echo "║        ✅ AMBIENTE PRONTO!         ║"
	@echo "╚════════════════════════════════════════╝"
	@echo ""
	@echo "🔗 Acessos:"
	@echo "  VS Code:  http://localhost:8443  (senha: devlab123)"
	@echo "  noVNC:    http://localhost:6080"
	@echo "  SSH:      ssh dev@localhost -p 2222 (senha: devlab123)"
	@echo ""
	@echo "💡 Dica: Use 'make help' para ver todos os comandos"
