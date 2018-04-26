module Stego
  class Supervisor
    attr_reader :thread_number, :target

    def initialize(target, thread_number=1)
      Stego.config.logger.info("Starting up Stego Supervisor #{Stego.config.kafka_urls.join('',)} with #{thread_number} threads")
      @target = target
      @thread_number = thread_number
    end

    def start
      (1..thread_number).map{ Thread.new{ thread_logic } }.each(&:join)
    end

    def thread_logic
      loop do
        begin
          Listener.create(target)
        rescue StandardError => err
          Stego.config.logger.error("Error on thread level #{err.class.name} : #{err.message}")
          Stego.config.error_catched(err)
        end

        break if Stego.shutdown_pending?
      end
    end
  end
end
