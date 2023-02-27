# === APACHE ===
FROM php:8.1.15-apache-bullseye as apache

ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

ARG APACHE_STATUS_USER
ARG APACHE_STATUS_PASSWORD
ENV APACHE_STATUS_USER=${APACHE_STATUS_USER}
ENV APACHE_STATUS_PASSWORD=${APACHE_STATUS_PASSWORD}

COPY ./sites-enabled/profile-fluid.conf /etc/apache2/sites-enabled/profile-fluid.conf

RUN apt update

# Устанавливаем зависимости для сборки
RUN apt -y install \
    rsync ca-certificates openssl openssh-server git tzdata openntpd \
    libxrender-dev fontconfig libc6-dev \
    default-mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg build-essential make python3 \
    nodejs npm libfreetype6 libfreetype6-dev libpng-dev libjpeg-dev libpng-dev \
    zlib1g libzip-dev

# Setup user authentification for status export
RUN htpasswd -cb /etc/apache2/.htpasswd ${APACHE_STATUS_USER} ${APACHE_STATUS_PASSWORD}

# Прокидываем права на файлы на пользователя Apache
RUN usermod -u ${UID} www-data
RUN groupmod -g ${GID} www-data

COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./mods-enabled/php.conf /etc/apache2/mods-enabled/php.conf

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Install additional PHP libraries
RUN docker-php-ext-install bcmath pdo_mysql gd zip

# Устанавливаем composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
 && chmod 755 /usr/bin/composer

# === DEV ===
FROM apache AS dev

USER www-data

COPY ./htdocs /var/www/html
# === /DEV ===

# === PROD ===
FROM apache AS prod

USER www-data

COPY ./htdocs /var/www/html

WORKDIR /var/www/html

RUN composer install

RUN npm install

RUN npm run prod
# === /PROD ===