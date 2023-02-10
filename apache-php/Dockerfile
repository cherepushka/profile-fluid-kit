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

# Setup user authentification for status export
RUN htpasswd -cb /etc/apache2/.htpasswd ${APACHE_STATUS_USER} ${APACHE_STATUS_PASSWORD}

# Configure standard server user
RUN usermod -u ${UID} www-data
RUN groupmod -g ${GID} www-data

COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./mods-enabled/php.conf /etc/apache2/mods-enabled/php.conf


# === DEV ===
FROM apache AS dev

COPY ./sites-enabled/dev/profile-fluid.conf /etc/apache2/sites-enabled/profile-fluid.conf

USER www-data

COPY ./htdocs /var/www/html
# === /DEV ===

# === PROD ===
FROM apache AS prod

COPY ./sites-enabled/prod/profile-fluid.conf /etc/apache2/sites-enabled/profile-fluid.conf

USER www-data

COPY ./htdocs /var/www/html
# === /PROD ===