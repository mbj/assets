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

    # Call rack app
    #
    # @param [Hash] env
    #
    # @return [Array]
    #
    # @api private
    #
    def call(env)
      name = env.fetch('PATH_INFO').gsub(prefix, '')
      asset = environment.get(name)
      if asset
        Response.build(200, {'Content-Type' => asset.mime.content_type}, asset.body)
      else
        Response.build(404, {'Content-Type' => 'text/plain; charset=utf-8'}, 'Not found')
      end
    end
  end
end
