module Assets
  class Environment

    # Environment with dynamic asset compilation
    class Dynamic < self
      include Adamantium, Concord.new(:rules)

      # Return index
      #
      # @return [Hash]
      #
      # @api private
      #
      def index
        rules.each_with_object({}) do |rule, index|
          index[rule.name] = rule
        end
      end
      memoize :index

      # Return rule for name
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
        index[name]
      end

      # Return asset for name
      #
      # @param [String] name
      #
      # @return [Asset]
      #   if found
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      def get(name)
        rule = rule(name)
        rule && rule.asset
      end

    end # Dynamic
  end  # Environment
end # Assets
