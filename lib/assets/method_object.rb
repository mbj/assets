module Assets
  # Mixin to define method objects
  class MethodObject < ::Module
    include Adamantium, Composition.new(:method_name)

    def included(descendant)
      super

      method_name = self.method_name

      descendant.define_singleton_method(:run) do |*args|
        new(*args).send(method_name)
      end
    end
  end
end
