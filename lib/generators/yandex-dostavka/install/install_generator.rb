# frozen_string_literal: true

module YandexDostavka
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def generate_install
      copy_file 'yandex_dostavka.yml', 'config/yandex_dostavka.yml'
      copy_file 'yandex_dostavka.rb', 'config/initializers/yandex_dostavka.rb'
    end
  end
end

