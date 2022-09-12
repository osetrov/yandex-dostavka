# Yandex Dostavka API

API wrapper для [Yandex Dostavka API](https://yandex.ru/dev/logistics/delivery-api/doc/about/intro.html)

# Оглавление
0. [Установка](#install)
    1. [Использование Rails](#using_rails)
    2. [Использование Ruby](#using_ruby)
    3. [Debug Logging](#debug_logging)
    4. [Custom logger](#custom_logger)
1. [Подготовка заявки](#part1)
   1. [Предварительная оценка стоимости доставки](#api_b2b_platform_pricing-calculator_post)
   2. [Получение интервалов доставки](#api_b2b_platform_offers_info_get)
2. [Точки самопривоза и ПВЗ](#part2)
   1. [Получение идентификатора населённого пункта](#api_b2b_platform_location_detect_post)
   2. [Получение списка точек самопривоза и ПВЗ](#api_b2b_platform_pickup-points_list_post)
3. [Основные запросы](#part3)
   1. [Создание заявки](#api_b2b_platform_offers_create_post)
   2. [Подтверждение заявки](#api_b2b_platform_offers_confirm_post)
   3. [Получение информации о заявке](#api_b2b_platform_request_info_get)
   4. [Получение информации о заявках во временном интервале](#api_b2b_platform_requests_info_get)
   5. [История статусов заявки](#api_b2b_platform_request_history_get)
   6. [Отмена заявки](#api_b2b_platform_request_cancel_post)
4. [Ярлыки и акты приема-передачи](#part4)
   1. [Получение ярлыков](#api_b2b_platform_request_generate-labels_post)
   2. [Получение актов приёма-передачи для отгрузки](#api_b2b_platform_request_get-handover-act_post)

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
dostavka = YandexDostavka::Request.new(token: "your_token")
```

Вы можете изменять `token`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
YandexDostavka::Request.timeout = 15
YandexDostavka::Request.open_timeout = 15
YandexDostavka::Request.symbolize_keys = true
YandexDostavka::Request.debug = false

YandexDostavka::Request.token = "your_token"
```

Либо в файле `config/initializers/yandex_dostavka.rb` для Rails.

## <a name="debug_logging"></a> Debug Logging

Измените `debug: true` чтобы включить логирование в STDOUT.

```ruby
dostavka = YandexDostavka::Request.new(token: "AgAAAADzeAQMAAAPeISvM_9LUkxCijQoFXOH5QE", debug: true)
```

### <a name="custom_logger"></a> Custom logger

`Logger.new` используется по умолчанию, но вы можете изменить на свой:

```ruby
dostavka = YandexDostavka::Request.new(token: "AgAAAADzeAQMAAAPeISvM_9LUkxCijQoFXOH5QE", debug: true, logger: MyLogger.new)
```

Или:

```ruby
YandexDostavka::Request.logger = MyLogger.new
```

## <a name="part1"></a> [Подготовка заявки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part1.html) 
### <a name="api_b2b_platform_pricing-calculator_post"></a> [Предварительная оценка стоимости доставки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part1/api_b2b_platform_pricing-calculator_post.html)
```ruby
body = { 
        client_price: 10000,
        destination: {
                address: "Санкт-Петербург, ул. Академика Павлова, д. 5"
        },
        payment_method: "already_paid",
        source: {
                address: "Санкт-Петербург, ул. Профессора Попова, д. 38"
        },
        tariff: "time_interval",
        total_assessed_price: 10000,
        total_weight: 1000
}
response = YandexDostavka::Request.pricing_calculator.create(body: body)
pricing_total = response.body[:pricing_total]
#=> "360 RUB"
```
### <a name="api_b2b_platform_offers_info_get"></a> [Получение интервалов доставки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part1/api_b2b_platform_offers_info_get.html)
```ruby
params = {
        station_id: "03840f16-3c53-400c-b382-1ecf30e06b64",
        full_address: "Санкт-Петербург, Професора Попова, 38",
        geo_id: 2
}
response = YandexDostavka::Request.offers.info.retrieve(params: params)
```
## <a name="part2"></a> [Точки самопривоза и ПВЗ](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part2.html)
### <a name="api_b2b_platform_location_detect_post"></a> [Получение идентификатора населённого пункта](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part2/api_b2b_platform_location_detect_post.html)
```ruby
body = {
        location: "Санкт-Петербург"
}
response = YandexDostavka::Request.location.detect.create(body: body)
variants = response.body[:variants]
#=> [{:geo_id=>2, :address=>"Россия, Санкт-Петербург"}] 
```
### <a name="api_b2b_platform_pickup-points_list_post"></a> [Получение списка точек самопривоза и ПВЗ](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part2/api_b2b_platform_pickup-points_list_post.html)
```ruby
body = {
        available_for_dropoff: true,
        payment_method: "already_paid",
        type: "pickup_point"
}
response = YandexDostavka::Request.pickup_points.list.create(body: body)
points = response.body[:points]
# =>
#         [{:id=>"03840f16-3c53-400c-b382-1ecf30e06b64",
#           ...
```
## <a name="part3"></a> [Основные запросы](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3.html)
### <a name="api_b2b_platform_offers_create_post"></a> [Создание заявки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_offers_create_post.html)
```ruby
body = {
        billing_info: {
                delivery_cost: 10000,
                payment_method: "card_on_receipt"
        },
        destination: {
                custom_location: {
                        details: {
                                comment: "БЦ Ривер Хаус",
                                full_address: "Санкт-Петербург, ул. Академика Павлова, 5",
                                room: "601"
                        }
                },
                interval: {
                        from: DateTime.now.to_i,
                        to: DateTime.tomorrow.to_datetime.to_i
                },
                "type": "custom_location"
        },
        info: {
                comment: "Позвонить за час",
                operator_request_id: "100023"
        },
        items: [
                {
                        "article": "55185",
                        billing_details: {
                                assessed_unit_price: 237900,
                                unit_price: 237900
                        },
                        count: 1,
                        name: "Автомобильный держатель Mage Safe Qi для iPhone, магнитный, черный",
                        place_barcode: "4680431123446"
                }
        ],
        places: [
                {
                        barcode: "4680431123446",
                        physical_dims: {
                                predefined_volume: 10000,
                                weight_gross: 1000
                        }
                }
        ],
        recipient_info: {
                email: "recipient@email.com",
                first_name: "Осетров",
                last_name: "Павел",
                partonymic: "Федорович",
                phone: "+7111111111111"
        },
        source: {
                platform_station: {
                        platform_id: "03840f16-3c53-400c-b382-1ecf30e06b64"
                }
        }
}
response = YandexDostavka::Request.offers("create").create(body: body)

```
### <a name="api_b2b_platform_offers_confirm_post"></a> [Подтверждение заявки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_offers_confirm_post.html)
### <a name="api_b2b_platform_request_info_get"></a> [Получение информации о заявке](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_request_info_get.html)
### <a name="api_b2b_platform_requests_info_get"></a> [Получение информации о заявках во временном интервале](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_requests_info_get.html)
### <a name="api_b2b_platform_request_history_get"></a> [История статусов заявки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_request_history_get.html)
### <a name="api_b2b_platform_request_cancel_post"></a> [Отмена заявки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part3/api_b2b_platform_request_cancel_post.html)
## <a name="part4"></a> [Ярлыки и акты приема-передачи](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part4.html)
### <a name="api_b2b_platform_request_generate-labels_post"></a> [Получение ярлыков](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part4/api_b2b_platform_request_generate-labels_post.html)
### <a name="api_b2b_platform_request_get-handover-act_post"></a> [Получение актов приёма-передачи для отгрузки](https://yandex.ru/dev/logistics/delivery-api/doc/ref/part4/api_b2b_platform_request_get-handover-act_post.html)