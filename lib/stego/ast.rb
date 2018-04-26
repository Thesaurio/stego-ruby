module Stego
  class AST
    attr_reader :producer,
                :target, :controller, :action, :params

    def initialize(producer)
      @producer = producer
    end

    def method_missing(sym, *args, &blk)
      return ast_setter(:target, sym) unless target
      return ast_setter(:controller, sym) unless controller
      @action = sym
      producer.publish(target, controller, action, args)
    end

    private

    def ast_setter(var, val)
      instance_variable_set("@#{var}".to_sym, val)
      return self
    end
  end
end
