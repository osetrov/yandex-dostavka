module YandexDostavka
  class Request
    attr_accessor :token, :api_endpoint,
                  :timeout, :open_timeout, :proxy, :ssl_options, :faraday_adapter, :symbolize_keys, :debug,
                  :logger, :test

    DEFAULT_TIMEOUT = 60
    DEFAULT_OPEN_TIMEOUT = 60

    def initialize(token: nil,
                   api_endpoint: nil, api_auth_method: nil, timeout: nil, open_timeout: nil, proxy: nil, ssl_options: nil,
                   faraday_adapter: nil, symbolize_keys: false, debug: false,
                   logger: nil, test: false)

      @path_parts = []
      @token = token || self.class.token || ENV['YANDEX_DOSTAVKA_TOKEN']
      @api_endpoint = api_endpoint || self.class.api_endpoint
      @api_endpoint = YandexDostavka::api_endpoint if @api_endpoint.nil?
      @timeout = timeout || self.class.timeout || DEFAULT_TIMEOUT
      @open_timeout = open_timeout || self.class.open_timeout || DEFAULT_OPEN_TIMEOUT
      @proxy = proxy || self.class.proxy || ENV['API_PROXY']
      @ssl_options = ssl_options || self.class.ssl_options || { version: "TLSv1_2" }
      @faraday_adapter = faraday_adapter || self.class.faraday_adapter || Faraday.default_adapter
      @symbolize_keys = symbolize_keys || self.class.symbolize_keys || false
      @debug = debug || self.class.debug || false
      @test = test || self.class.test || false
      @logger = logger || self.class.logger || ::Logger.new(STDOUT)
    end

    def method_missing(method, *args)
      @path_parts << method.to_s.downcase.gsub("_", "-")
      @path_parts << args if args.length > 0
      @path_parts.flatten!
      self
    end

    def respond_to_missing?(method_name, include_private = false)
      true
    end

    def send(*args)
      if args.length == 0
        method_missing(:send, args)
      else
        __send__(*args)
      end
    end

    def path
      @path_parts.join('/')
    end

    def create(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def update(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).post(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def retrieve(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).get(params: params, headers: headers, body: body)
    ensure
      reset
    end

    def delete(params: nil, headers: nil, body: {})
      APIRequest.new(builder: self).post(params: params, headers: headers, body: {})
    ensure
      reset
    end

    protected

    def reset
      @path_parts = []
    end

    class << self
      attr_accessor :token,
                    :timeout, :open_timeout, :api_endpoint, :proxy, :ssl_options, :faraday_adapter, :symbolize_keys,
                    :debug, :logger, :test

      def method_missing(sym, *args, &block)
        new(token: self.token,
            api_endpoint: self.api_endpoint,
            timeout: self.timeout, open_timeout: self.open_timeout, faraday_adapter: self.faraday_adapter,
            symbolize_keys: self.symbolize_keys, debug: self.debug,
            proxy: self.proxy, ssl_options: self.ssl_options, logger: self.logger,
            test: self.test).send(sym, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        true
      end
    end
  end
end
