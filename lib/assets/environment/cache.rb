module Assets
  class Environment
    # Environment that caches assets
    class Cache < self
      include Adamantium::Flat, Equalizer.new(:environment)

      # Return inner environment
      #
      # @return [Environment]
      #
      # @api private
      #
      attr_reader :environment

      # Build cache environemnt
      #
      # @param [Enumerable<Rules>] rules
      #
      # @return [Cache]
      #
      # @api private
      #
      def self.build(rules)
        new(Dynamic.new(rules))
      end

      # Initialize object
      #
      # @param [Environment] environment
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(environment)
        @environment, @cache = environment, {}
      end

      # Return rule
      #
      # @param [String] name
      #
      # @return [Rule]
      #   if found
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      def rule(name)
        environment.rule(name)
      end

      # Return asset
      #
      # @param [String] name
      #
      # @return [Asset]
      #   if found
      #
      # @return [nil]
      #   otherwise
      #
      def get(name)
        rule = rule(name)
        return unless rule

        asset = @cache.fetch(name) do
          return miss(rule)
        end

        hit(rule, asset)
      end

    private

      # Process cache hit
      #
      # @param [Rule] rule
      # @param [Asset] asset
      #
      # @return [Asset]
      #
      # @api private
      #
      def hit(rule, asset)
        if rule.fresh_at?(asset.created_at)
          return asset
        end

        miss(rule)
      end

      # Process cache miss
      #
      # @param [Rule] rule
      #
      # @return [Asset]
      #   if found
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      def miss(rule)
        @cache[rule.name] = rule.asset
      end

    end # Cache
  end # Environment
end # Assets
