module Assets
  # Rack compatible asset server
  class Server
    include Adamantium, Equalizer.new(:environment, :prefix)

    # Return environment
    #
    # @return [Environment]
    #
    # @api private
    #
    attr_reader :environment

    # Return prefix
    #
    # @return [Regexp]
    #
    # @api private
    #
    attr_reader :prefix

    # Initialize object
    #
    # @param [Environment] environment
    #
    # @param [String] prefix
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(environment, prefix = '')
      @environment = environment
      @prefix = Regexp.compile("\\A#{Regexp.escape(prefix)}")
    end

    class Found
    end

    HEADERS   = IceNine.deep_freeze('Cache-Control' => 'max-age=120, must-revalidate')
    NOT_FOUND = Response.build(404, HEADERS.merge('Content-Type' => Assets::Mime::TXT.content_type), 'Not Found')

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
        Response.build(200, HEADERS.merge('Content-Type' => asset.mime.content_type), asset.body)
      else
        NOT_FOUND
      end
    end
  end
end
