# README

## Requerimientos
* Ruby >= 2.4.0
* Bundler
* PostgreSQL

## Deploy

**IMPORTANTE** Si hay cambios en el `application.yml`, actualizarlo en el servidor remoto. De lo contrario el deploy fallara.

Para hacer el deploy
```ruby
cap production deploy
```

Para manejar Delayed::Job del servidor de producción se tienen los siguientes comandos
```ruby
cap production delayed_job:restart  # Restart the delayed_job process
cap production delayed_job:start    # Start the delayed_job process
cap production delayed_job:status   # Status of the delayed_job process
cap production delayed_job:stop     # Stop the delayed_job process
```

De ser necesario ejecutar algun comando de Rails directamente en el servidor de producción dirigirse a la carpeta del deploy `cd /var/www/Inventario/current/` y luego usar la siguiente sintaxis
```ruby
RAILS_ENV=production bundle exec <comando a ejecutar>
```
