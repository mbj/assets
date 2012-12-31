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

  end
end
