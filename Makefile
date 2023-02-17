build:
	@docker compose -f docker-compose.yml build

build-local:
	@docker compose -f docker-compose.yml -f local.docker-compose.yml build

up:
	@docker compose -f docker-compose.yml up -d

up-local:
	@docker compose -f docker-compose.yml -f local.docker-compose.yml up -d

stop:
	@docker compose -f docker-compose.yml -f local.docker-compose.yml stop

up-traefik:
	docker run -d --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-p 80:80 -p 443:443 \
		--network indocker-app-network \
		--name indocker.app \
		quay.io/indocker/app:1

stop-traefik:
	docker stop indocker.app