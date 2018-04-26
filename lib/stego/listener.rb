require 'ostruct'

module Stego
  class Listener
    @@listeners = []

    attr_reader :kafka, :consumer, :target

    def self.create(target)
      listener = new(target.to_s)
      @@listeners << listener
      listener.listen
    end

    def initialize(target)
      @target = target
      @kafka = Stego.config.new_kafka
    end

    def listen
      @consumer = kafka.consumer(group_id: target)
      consumer.subscribe(target)
      consumer.each_message { |msg| handle_message(msg.value) }
    end

    def handle_message(payload)
      msg = OpenStruct.new(JSON.parse(payload).deep_symbolize_keys)
      BusController.dispatch(msg, kafka)
    rescue StandardError => err
      Stego.config.logger.error("Error while handling message #{err.class.name} : #{err.message}. Moving message to morgue for investigation.")
      Stego.config.error_catched(err)
    end

    def stop
      return unless @consumer
      consumer.stop
    end

    def self.stop_all
      @@listeners.each { |l| l.stop }
    end
  end
end

