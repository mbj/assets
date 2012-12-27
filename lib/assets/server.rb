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
      path_info = env.fetch('PATH_INFO').gsub(prefix, '')
      asset = environment.get(path_info)
      Response.build(200, {'Content-Type' => asset.content_type}, asset.body)
    end
  end
end
