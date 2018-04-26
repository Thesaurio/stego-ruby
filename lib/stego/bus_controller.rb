module Stego
  class BusController
    attr_reader :params, :producer

    def self.controller_key(key)
      class_variable_set(:@@key, key)
    end

    def self.inherited(other)
      other.class_variable_set(:@@before_actions, [])
      other.class_variable_set(:@@after_actions, [])
    end

    def self.before_actions
      class_variable_get(:@@before_actions)
    end

    def self.after_actions
      class_variable_get(:@@after_actions)
    end

    def self.before_action(sym, conditions={})
      before_actions << {
        symbol: sym,
        conditions: conditions
      }
    end

    def self.after_action(sym, conditions={})
      after_actions << {
        symbol: sym,
        conditions: conditions
      }
    end

    def self.dispatch(message, kafka=nil)
      controller = select_controller(message.controller.to_sym)
      raise StandardError.new "Controller '#{message.controller}' not found" unless controller
      controller.new( message.params || {}, Producer.new(kafka) ).dispatch(message.action.to_sym)
    end

    def self.select_controller(sym)
      self.descendants.select{ |k| k.class_variable_get(:@@key) == sym }.first
    end

    def dispatch(action)
      producer.begin_transaction
      trigger_hooks(self.class.before_actions, action)
      send(action)
      trigger_hooks(self.class.after_actions, action)
      producer.commit
    rescue StandardError => err
      producer.rollback
      raise err
    end

    def initialize(params, producer)
      @params = params
      @producer = producer
    end

    def bus
      AST.new(producer)
    end

    def trigger_hooks(list, action)
      list.each do |hook|
        return if hook[:conditions].keys.include?(:only) && !eq_or_include(hook[:conditions][:only], action)
        return if hook[:conditions].keys.include?(:except) && eq_or_include(hook[:conditions][:except], action)
        send(hook[:symbol])
      end
    end

    def eq_or_include(a, sym)
      return a.include?(sym) if a.is_a?(Array)
      a == sym
    end
  end
end

