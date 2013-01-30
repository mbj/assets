module Assets

  # Abstract base class for rules that generate assets
  class Rule 
    include Adamantium, AbstractType

    # Return asset
    #
    # @return [Asset]
    #
    # @api private
    #
    def asset
      Evaluator.new(self).asset
    end

    # Return body
    #
    # @return [String]
    #
    # @api private
    #
    abstract_method :body

    # Return mime 
    #
    # @return [Mime]
    #
    # @api private
    #
    abstract_method :mime

    # Return updated at
    #
    # @return [Time]
    #
    # @api private
    #
    abstract_method :updated_at

    # Test if asset is fresh at specific time
    #
    # @param [Time] time
    #
    # @return [true]
    #   if asset is fresh at time
    #
    # @return [false]
    #
    # @api private
    #
    def fresh_at?(time)
      time >= updated_at
    end

  end
end
