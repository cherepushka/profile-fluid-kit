# === APACHE ===
FROM php:8.2.6-apache-bullseye as src

ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

ARG APACHE_STATUS_USER
ARG APACHE_STATUS_PASSWORD
ENV APACHE_STATUS_USER=${APACHE_STATUS_USER}
ENV APACHE_STATUS_PASSWORD=${APACHE_STATUS_PASSWORD}

COPY ./apt-sources.list /etc/apt/sources.list

RUN apt update

# Устанавливаем зависимости для сборки
RUN apt -y install --no-install-recommends \
    rsync ca-certificates openssl openssh-server git tzdata openntpd \
    libxrender-dev fontconfig libc6-dev \
    default-mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg build-essential make python3 \
    nodejs npm libfreetype6 libfreetype6-dev libpng-dev libjpeg-dev libpng-dev \
    zlib1g libzip-dev 

# Устанавливаем конкретную версию nodejs
RUN npm cache clean -f && \
    npm install -g n && \
    n 18.13
  
RUN npm install -g npm@9.8.1

FROM src as apache

# Данные для аутентификации для экспорта статуса сервера
RUN htpasswd -cb /etc/apache2/.htpasswd ${APACHE_STATUS_USER} ${APACHE_STATUS_PASSWORD}

# Прокидываем права на файлы на пользователя Apache
RUN usermod -u ${UID} www-data
RUN groupmod -g ${GID} www-data

RUN usermod -d /var/www www-data
RUN chown -R www-data:www-data /var/www

COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./sites-enabled/profile-fluid.conf /etc/apache2/sites-enabled/profile-fluid.conf
COPY ./mods-enabled/php.conf /etc/apache2/mods-enabled/php.conf

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# PHP расширения
RUN docker-php-ext-install bcmath pdo_mysql gd zip pcntl

RUN docker-php-ext-configure pcntl --enable-pcntl

# Устанавливаем composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
 && chmod 755 /usr/bin/composer

COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

CMD ["/usr/local/bin/entrypoint"]

# === DEV ===
FROM apache AS dev

RUN pecl install xdebug && docker-php-ext-enable xdebug
# Enable XDebug
ADD xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

USER www-data
WORKDIR /var/www/html
# === /DEV ===

# === PROD ===
FROM apache AS prod

USER www-data
WORKDIR /var/www/html
# === /PROD ===
