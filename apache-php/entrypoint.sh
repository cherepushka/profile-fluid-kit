#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-http}

if [ "$role" = "http" ]; then
  echo "Running Apache"

    exec apache2-foreground

elif [ "$role" = "queue" ]; then
    echo "Running the queue..."

    supervisord -c /etc/supervisor/supervisord.conf

elif [ "$role" = "scheduler" ]; then
    echo "Running Scheduler"

    while [ true ]
      do
        php /var/www/html/artisan schedule:run --verbose --no-interaction >> /dev/stdout 2>&1 \
          & sleep 60
      done
else
    echo "Could not match the container role \"$role\""
    exit 1
fi
