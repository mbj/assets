module Assets
  # Asset request handler
  class Handler
    include Adamantium, Composition.new(:environment, :prefix)

    # Instantiate object
    #
    # @param [Environment] environment
    # @param [String] prefix
    #
    # @return [undefined]
    #
    # @api private
    #
    def self.new(environment, prefix = '')
      super(environment, Regexp.compile(%r(\A#{Regexp.escape(prefix)})))
    end

    # Call handler
    #
    # @param [Application] application
    # @param [Request] request
    #
    # @return [Response]
    #
    # @api private
    #
    def call(_application, request)
      name = request.path_info.gsub(prefix, '')
      asset = environment.get(name)
      if asset
        Responder.run(request, asset)
      else
        Responder::NOT_FOUND
      end
    end

  end
end
