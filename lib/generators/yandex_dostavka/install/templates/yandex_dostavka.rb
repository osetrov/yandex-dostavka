require 'yandex-dostavka'

YandexDostavka.setup do |config|
  if File.exist?('config/yandex_dostavka.yml')
    processed = YAML.load_file('config/yandex_dostavka.yml')[Rails.env]

    processed.each do |k, v|
      config::register k.underscore.to_sym, v
    end

    config::Request.token = YandexDostavka.token || ENV['YANDEX_DOSTAVKA_TOKEN']

    config::Request.timeout = 60
    config::Request.open_timeout = 60
    config::Request.symbolize_keys = true
    config::Request.debug = false
  end
end