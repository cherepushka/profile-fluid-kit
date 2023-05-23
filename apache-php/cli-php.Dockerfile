# === APACHE ===
FROM php:8.2.6-cli

ARG UID
ARG GID
ENV UID=${UID}
ENV GID=${GID}

COPY ./apt-sources.list /etc/apt/sources.list

RUN apt update

RUN apt -y install \
    rsync ca-certificates openssl openssh-server git tzdata openntpd \
    libxrender-dev fontconfig libc6-dev cron \
    default-mysql-client gnupg binutils-gold autoconf \
    g++ gcc gnupg build-essential make python3 \
    nodejs npm libfreetype6 libfreetype6-dev libpng-dev libjpeg-dev libpng-dev \
    zlib1g libzip-dev

# Supervisor
RUN apt -y install supervisor

COPY ./cli-supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./cli-supervisor/laravel-queue.conf /etc/supervisor/conf.d/laravel-queue.conf

# Прокидываем права на файлы на пользователя
RUN usermod -u ${UID} www-data
RUN groupmod -g ${GID} www-data

RUN usermod -d /var/www www-data
RUN chown -R www-data:www-data /var/www

# Install additional PHP modules
RUN docker-php-ext-install bcmath pdo_mysql gd zip pcntl
RUN docker-php-ext-configure pcntl --enable-pcntl

# Устанавливаем composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
 && chmod 755 /usr/bin/composer

COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
CMD ["/usr/local/bin/entrypoint"]

WORKDIR /var/www/html
