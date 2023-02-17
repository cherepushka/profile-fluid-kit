# profile.fluid-line dev environment

Окружение для разработки и продакшана сайта
личного кабинета profile.fluid-line.ru

## Локальное окружение

При запуске окружения локально сайт буде доступен по адресу https://fluid-profile.indocker.app/ .
Благодаря reverse-proxy с Traefik (https://habr.com/ru/post/714916/) который включен в Makefile,
не придется вносить дополнительные изменения в файл `hosts` операционной системы или же ставить 
самоподписанные сертификат.

1. Копируем репозиторий с кодом в /apache-php/htdocs
2. Копируем корневой `.env.example` в `.env` и прописываем туда значения переменных
2. Запускаем в терминале `docker network create indocker-app-network`
3. Запускаем в терминале `make build-local`
4. Запускаем в терминале `make up-local`
5. Запускаем в терминале `make up-traefik`