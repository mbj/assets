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

    # Return renamed asset
    #
    # @param [String] name
    #
    # @return [Rule::Rename]
    #
    # @api private
    #
    def rename(name)
      Rename.new(name, self)
    end

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

  private

    # Helper method to tag strings as binary
    #
    # @param [String]
    #
    # @return [String]
    #
    # @api private
    #
    def binary(string)
      string.force_encoding(Encoding::ASCII_8BIT)
    end

  end # Rule
end # Assets
