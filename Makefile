build-prod:
	@docker compose \
		-f docker-compose.yml \
		-f prod.docker-compose.yml build

build-dev:
	@docker compose \
		-f docker-compose.yml \
		-f dev.docker-compose.yml build

up-prod:
	@docker compose \
		-f docker-compose.yml \
		-f prod.docker-compose.yml up -d

up-dev:
	@docker compose \
		-f docker-compose.yml \
		-f dev.docker-compose.yml up -d

stop:
	@docker compose \
		-f docker-compose.yml \
		-f dev.docker-compose.yml \
		-f prod.docker-compose.yml stop

# < https://habr.com/ru/post/714916 >
up-dev-traefik:
	docker run -d --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-p 80:80 -p 443:443 \
		--network indocker-app-network \
		--name indocker.app \
		quay.io/indocker/app:1

stop-dev-traefik:
	docker stop indocker.app
# </>