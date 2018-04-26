require 'ostruct'

module Stego
  class Producer
    attr_reader :kafka, :producer

    def initialize(kafka=nil)
      @kafka = kafka || Stego.config.new_kafka
    end

    def transaction(&blk)
      begin_transaction
      blk.call
      commit
    rescue StandardError => err
      rollback
      raise err
    end

    def begin_transaction
      @producer = kafka.producer
    end

    def publish(target, controller, action, params)
      message = {
        target: target,
        controller: controller,
        action: action,
        params: params
      }.to_json

      return kafka.deliver_message(message, topic: target.to_s) unless producer
      producer.produce(message, topic: target.to_s)
    end

    def commit
      return unless producer
      producer.deliver_messages
      @producer = nil
    end

    def rollback
      return unless producer
      producer.clear_buffer
      @producer = nil
    end
  end
end

