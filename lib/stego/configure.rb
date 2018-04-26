module Stego
  class Configuration
    include Singleton

    attr_accessor :logger, :kafka_urls, :kafka_options

    def initialize
      @logger = Logger.new(STDOUT)
      @kafka_urls = ['localhost:9092']
      @kafka_options = {}
    end

    def new_kafka
      Kafka.new(
        @kafka_urls,
        @kafka_options
      )
    end

    def error_catched(err)
      return unless @on_error
      @on_error.call(err)
    end

    def on_error(&blk)
      @on_error = blk
    end
  end
end
