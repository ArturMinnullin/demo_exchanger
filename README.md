# Demoexchanger

Ruby on rails project to exchange usdt to btc

## Installation
```sh
bundle
rake db:migrate
EDITOR="code --wait" bin/rails credentials:edit # set the private key for exchanger
```
## Run
```sh
rails s
# or
docker-compose up
```
### Admin panel
```sh
localhost:3000/admin/transactions # admin/password
```

## Run tests
```sh
bundle exec rspec
```
