module Assets
  class Rule 
    class Compile < self
      include Concord.new(:input)

      # Return name
      #
      # @return [String]
      #
      # @api private
      #
      def name
        input.name
      end

      # Return updated at
      #
      # @return [Time]
      #
      # @api private
      #
      def updated_at
        input.updated_at
      end

      # Return target name
      #
      # @return [String]
      #
      # @api private
      #
      def target_name
        regexp = %r(#{Regexp.escape(input.extname)}\z)
        name.gsub(regexp, mime.extname)
      end
      memoize :target_name

      # Return registry
      #
      # @return [Hash]
      #
      # @api private
      #
      def self.registry
        @registry ||= {}
      end

      # protected_class_method :registry
      singleton_class.send(:protected, :registry)

      # Register handler
      #
      # @param [Mime] mime
      #
      # @return [undefined]
      #
      # @api private
      #
      def self.handle(mime)
        Compile.registry[mime]=self
      end
      private_class_method :handle

      # Build compiler rule
      #
      # @param [Rule::File] rule
      #
      # @return [Rule::Compile]
      #
      # @api private
      #
      def self.build(rule)
        builder = Compile.registry.fetch(rule.mime)
        compiler = builder.new(rule)
        Rename.new(compiler.target_name, compiler)
      end

      # Return mime type
      #
      # @return [Mime]
      #
      # @api private
      #
      def mime
        self.class.mime
      end

      # Return mime type
      #
      # @return [Mime]
      #
      # @api private
      #
      def self.mime
        self::MIME
      end
    end
  end
end
