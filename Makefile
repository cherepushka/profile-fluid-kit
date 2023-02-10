up-traefik:
	docker run -d --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-p 80:80 -p 443:443 \
		--network indocker-app-network \
		--name indocker.app \
		quay.io/indocker/app:1 \
		--entrypoint="/bin/traefik --log.level=DEBUG"

stop-traefik:
	docker stop indocker.app