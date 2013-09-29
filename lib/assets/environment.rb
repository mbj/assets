module Assets

  # Abstract base class for asset environments
  class Environment
    include AbstractType

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
    abstract_method :rule

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

    # Return URL
    #
    # @param [String] name
    #
    # @return [String] url
    #
    # @raise [AssetNotFoundError]
    #   otherwise
    #
    # @api private
    #
    abstract_method :url

  end # Environment
end # Assets
