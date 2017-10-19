# README

## Deploy

*IMPORTANTE* Si hay cambios en el `application.yml`, actualizarlo en el servidor remoto.

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