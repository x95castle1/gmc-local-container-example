# ==========================================
# CONFIGURATION VARIABLES
# ==========================================
IMAGE_NAME = gemfire-management-console
TAG        = 1.4.5
JAR_NAME   = gemfire-management-console-$(TAG).jar
PROPERTIES = application.properties

.PHONY: help check-jar up down restart standalone-build standalone-run standalone-stop clean

# Default command when you type just 'make'
help:
	@echo "============================================================="
	@echo " Tanzu GemFire Management Console Automation Shortcuts"
	@echo "============================================================="
	@echo "Docker Compose Commands:"
	@echo "  make start          - Start GMC using Docker Compose (detaches)"
	@echo "  make stop           - Stop and remove Docker Compose containers"
	@echo "  make restart        - Restart the Compose container to apply property updates"
	@echo "  make logs           - Stream container initialization logs"
	@echo ""
	@echo "Standalone Docker Commands (No Compose):"
	@echo "  make s-build        - Build a standalone local Docker image"
	@echo "  make s-run          - Run the standalone image with your local application.properties"
	@echo "  make s-stop         - Stop and remove the standalone container"
	@echo ""
	@echo "Utility:"
	@echo "  make clean          - Remove dangling images and system caches"
	@echo "============================================================="

# Internal safety check to ensure the JAR file wasn't accidentally deleted/forgotten
check-jar:
	@if [ ! -f ./$(JAR_NAME) ]; then \
		echo "ERROR: ./$(JAR_NAME) not found!"; \
		echo "Please place your Broadcom JAR file in this directory first."; \
		exit 1; \
	fi

# ==========================================
# DOCKER COMPOSE SHORTCUTS
# ==========================================

start:
	docker compose up -d --build
	@echo "Waiting for GMC to be ready..."
	@until [ "$$(docker inspect --format='{{.State.Health.Status}}' gemfire-management-console 2>/dev/null)" = "healthy" ]; do \
		printf '.'; \
		sleep 2; \
	done
	@echo ""
	@echo "GMC is ready! Visit http://localhost:8080"

stop:
	docker compose down

restart:
	docker compose restart gemfire-management-console

logs:
	docker compose logs -f gemfire-management-console

# ==========================================
# STANDALONE DOCKER SHORTCUTS
# ==========================================

s-build: check-jar
	docker build -t $(IMAGE_NAME)-standalone:$(TAG) .

s-run:
	@docker rm -f $(IMAGE_NAME)-standalone 2>/dev/null || true
	@echo "Starting standalone container..."
	docker run -d \
		--name $(IMAGE_NAME)-standalone \
		-p 8080:8080 \
		-v $(PWD)/$(PROPERTIES):/opt/gemfire/application.properties:ro \
		$(IMAGE_NAME)-standalone:$(TAG)
	@echo "Container running! Access at http://localhost:8080"

s-stop:
	docker stop $(IMAGE_NAME)-standalone || true
	docker rm $(IMAGE_NAME)-standalone || true

# ==========================================
# CLEANUP UTILITIES
# ==========================================
clean: s-stop down
	docker system prune -f
