module Assets
  class Rule

    # Rule to rename other rule
    class Rename < self

      # Initialize object
      #
      # @param [String] name
      #   the new logical name
      #
      # @param [Rule] rule
      #   the rule to rename
      # 
      include Composition.new(:name, :rule)

      # Return body
      #
      # @return [String]
      #
      # @api private
      #
      def body
        rule.body
      end

      # Return mime
      #
      # @return [Mime]
      #
      # @api rpivate
      #
      def mime
        rule.mime
      end

      # Return updated at
      #
      # @return [Time]
      #
      # @api private
      #
      def updated_at
        rule.updated_at
      end

    end
  end
end
