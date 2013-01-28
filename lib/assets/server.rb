module Assets
  # Rack compatible asset server
  class Server
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
      super(environment, Regexp.compile("\\A#{Regexp.escape(prefix)}"))
    end

    HEADERS   = IceNine.deep_freeze('Cache-Control' => 'max-age=120, must-revalidate')
    NOT_FOUND = Response.build(
      404, 
      HEADERS.merge('Content-Type' => Assets::Mime::TXT.content_type), 
      'Not Found'
    )

    # Call rack app
    #
    # @param [Request] request
    #
    # @return [Response]
    #
    # @api private
    #
    def call(request)
      name = request.path_info.gsub(prefix, '')
      asset = environment.get(name)
      if asset
        asset_response(asset)
      else
        NOT_FOUND
      end
    end

    # Return asset response
    #
    # @return [Response]
    #
    # @api private
    #
    def asset_response(asset)
      Response.build(
        200,
        HEADERS.merge(
          'Content-Type' => asset.mime.content_type,
          'Last-Modified' => asset.created_at.httpdate
        ),
        asset.body
      )
    end
  end
end
