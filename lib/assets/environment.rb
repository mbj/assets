module Assets

  # Abstract base class for asset environments
  class Environment
    include Adamantium, AbstractType

    # Retrun asset
    #
    # @return [Asset]
    #
    # @api private
    # 
    abstract_method :get

    # Static enviornment with precompiled assets
    class Static

      # Initialize object
      #
      # @param [Enumerable<Asset>] assets
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(assets)
        @index = assets.each_with_object({}) do |asset, index|
          index[asset.logical]=asset
        end
      end

      # Return asset
      #
      # @param [String] logical
      #   logical name of asset
      #
      # @return [Asset]
      #
      def get(logical)
        @index.fetch(logical)
      end
    end

    class Dynamic
      attr_reader :root
      private :root

      attr_reader :rules
      private :rules

      # Initialize object
      #
      # @param [Pathname] root
      # @param [Enumerable<Rule>] rules
      #
      # @api private
      #
      def initialize(root, rules)
        @root = root
        @rules = {}
        rules.each do |rule|
          @rules[rule.logical]=rule
        end
      end

      # Return absolute path for logical name
      #
      # @return [Pathname]
      #
      # @api private
      def path(logical)
        root.join(logical)
      end

      # Return rule for logical name
      #
      # @param [String] logical
      #
      # @return [Rule]
      #
      # @api private
      #
      def rule(logical)
        rules.fetch(logical)
      end

      # Return asset for logical name
      #
      # @param [String] logical
      #
      # @return [Asset]
      #
      # @api private
      #
      def get(logical)
        Lookup.run(self, logical)
      end
    end
  end
end
