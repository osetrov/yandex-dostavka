# Yandex Dostavka API

API wrapper для Yandex Dostavka API

# Оглавление
0. [Установка](#install)
    1. [Использование Rails](#using_rails)
    2. [Использование Ruby](#using_ruby)
    3. [Debug Logging](#debug_logging)
    4. [Custom logger](#custom_logger)

# <a name="install"></a> Установка

### Получение OAuth-токена:

1. Войдите в [Кабинет Корпоративного Клиента Яндекс Доставки](https://dostavka.yandex.ru/change/) с помощью выданного вам логина и пароля.
Перейдите на вкладку Профиль компании.
2. В разделе Токен для API нажмите Получить.
3. На странице https://oauth.yandex.ru нажмите Разрешить.
4. В Кабинете Корпоративного Клиента Яндекс Доставки на вкладке Профиль компании в разделе Токен для API будет отображен ваш OAuth-токен.

## Ruby
    $ gem install yandex-dostavka
## Rails
добавьте в Gemfile:

    gem 'yandex-dostavka'

и запустите `bundle install`.

Затем:

    rails g yandex_dostavka:install

## <a name="using_rails"></a> Использование Rails

В файл `config/yandex_dostavka.yml` вставьте ваши данные

## <a name="using_ruby"></a> Использование Ruby

Сначала создайте экземпляр объекта `YandexDostavka::Request`:

```ruby
dostavka = YandexDostavka::Request.new(api_key: "***")
```

Вы можете изменять `api_key`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
YandexDostavka::Request.timeout = 15
YandexDostavka::Request.open_timeout = 15
YandexDostavka::Request.symbolize_keys = true
YandexDostavka::Request.debug = false

YandexDostavka::Request.api_key = "your_api_key"
```

Либо в файле `config/initializers/yandex_dostavka.rb` для Rails.

## <a name="debug_logging"></a> Debug Logging

Измените `debug: true` чтобы включить логирование в STDOUT.

```ruby
dostavka = YandexDostavka::Request.new(api_key: "***", debug: true)
```

### <a name="custom_logger"></a> Custom logger

`Logger.new` используется по умолчанию, но вы можете изменить на свой:

```ruby
dostavka = YandexDostavka::Request.new(api_key: "***", debug: true, logger: MyLogger.new)
```

Или:

```ruby
YandexDostavka::Request.logger = MyLogger.new
```

# <a name="examples"></a> Примеры