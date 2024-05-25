#!/bin/bash
docker compose exec -w /var/www/html -u $(id -u):$(id -g) app php artisan "$@"
