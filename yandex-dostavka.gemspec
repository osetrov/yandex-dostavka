lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yandex-dostavka/version"
Gem::Specification.new do |s|
  s.name        = 'yandex-dostavka'
  s.version     = YandexDostavka::VERSION
  s.date        = '2022-09-12'
  s.summary     = "YandexDostavka API"
  s.description = ""
  s.authors     = ["Pavel Osetrov"]
  s.email       = 'pavel.osetrov@me.com'
  s.files = Dir['lib/**/*', 'LICENSE', 'README.markdown']

  s.homepage    = 'https://github.com/osetrov/yandex-dostavka'
  s.license       = 'MIT'

  s.add_dependency('faraday', '>= 2.0.0')
  s.add_dependency('faraday-gzip', '>= 0.1.0')

  s.add_dependency('multi_json', '>= 1.11.0')
  s.add_dependency('irb', '>= 1.3.6')

  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.5'
end