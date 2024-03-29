# profile.fluid-line environment

Окружение для разработки и продакшна сайта
личного кабинета profile.fluid-line.ru

## DEV окружение

1. Копируем репозиторий с кодом в `./apache-php/htdocs`
2. Копируем корневой `.env.example` в `.env` и прописываем туда значения переменных, где после `=` пустота
3. Запускаем в терминале `docker network create indocker-app-network`
4. Запускаем в терминале `make build-dev`
5. Запускаем в терминале `make up-dev`
6. Запускаем в терминале `make up-dev-traefik`
7. Далее выполняем шаги установки из репозитория с кодом

После этого будут доступны:
* http://localhost:`MINIO_EXTERNAL_PORT`, где `MINIO_EXTERNAL_PORT` - значение переменной из `.env` файла. Это админ панель `MinIO`.  `STORAGE_ACCESS_KEY_ID` и `STORAGE_SECRET_ACCESS_KEY` переменные из `.env` файла - логин и пароль соответсвенно
* Само S3 хранилище по `${IP S3 контейнера}:9000`, где `${IP S3 контейнера}` можно узнать через команду:  
`docker inspect profile-fluid_minio -f '{{(index .NetworkSettings.Networks "profile-fluid").IPAddress}}'`  
(по этому адресу можно обратиться к S3 из других контейнеров)
* * `KEY ID` - переменная `STORAGE_ACCESS_KEY_ID`
* * `SECRET KEY` - переменная `STORAGE_SECRET_ACCESS_KEY`
* https://fluid-profile.indocker.app - локальный адрес сайта, по которому он будет доступен из браузера
* `XDebug` для PHP по адресу `127.0.0.1:9003`
* MariaDB (Mysql) база данных по адресу:
* * Хост: `127.0.0.1` (`profile-fluid_mariadb` - хост внутри контейнеров)
* * Порт: `DB_EXTERNAL_PORT` из .env файла (`3306` - для доступа из других контейнеров)
* * Логин: `DB_USER` из .env файла
* * Пароль: `DB_USER_PASSWORD` из .env файла
* * Имя базы: `DB_DATABASE` из .env файла

## PROD окружение

1. Копируем репозиторий с кодом в `./apache-php/htdocs`
2. Копируем корневой `.env.example` в `.env` и прописываем туда значения переменных, где после `=` пустота (все что в группе `DEV_ONLY` можно не заполнять)
4. Запускаем в терминале `make build-prod`
5. Запускаем в терминале `make up-prod`
7. Далее выполняем шаги установки из репозитория с кодом

* Рассчитывается, что подключение к БД будет мастер нода из кластера Mysql в Яндекс.Cloud (в репозитории с кодом указан SSL сертификат для этого подключения).
* S3 сервер также будет внешний. В данном случае расчитывается, что это Object Storage от того же Яндекс.Cloud
* `XDebug` - отключен
