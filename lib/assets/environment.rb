module Assets

  # Abstract base class for asset environments
  class Environment
    include Adamantium, AbstractType

    # Return asset
    #
    # @return [Asset]
    #   if found
    #
    # @return [nil]
    #   otherwise
    #
    # @api private
    # 
    abstract_method :get

  end
end
