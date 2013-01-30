module Assets
  # Abstract base class for asset responders
  class Responder
    include AbstractType, Joy::Responder, Composition.new(:asset)

    HEADERS   = IceNine.deep_freeze('Cache-Control' => 'max-age=120, must-revalidate')
    NOT_FOUND = Response.build(
      404, 
      HEADERS.merge('Content-Type' => Assets::Mime::TXT.content_type), 
      'Not Found'
    )

    # Run responder
    #
    # @param [Request] request
    # @param [Asset] asset
    #
    # @return [Response] response
    #
    # @api private
    #
    def self.run(request, asset)
      timestamp = request.if_modified_since

      responder = 
        if timestamp && asset.fresh_at?(timestamp)
          NotModified
        else
          New
        end

      responder.call(asset)
    end

    # Return response
    #
    # @return [Response]
    #
    # @api private
    #
    def response
      Response.new(status, headers, body)
    end

  private

    # Return status code
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def status
      self.class::STATUS
    end

    # Return headers
    #
    # @return [Hash]
    #
    # @api private
    #
    def headers
      HEADERS.merge('Last-Modified' => asset.created_at.httpdate)
    end

    # Return content type header value
    #
    # @return [String]
    #
    # @api private
    #
    def content_type
      asset.mime.content_type
    end

    # Not modified responder
    class NotModified < self
      STATUS = Response::Status::NOT_MODIFIED

    private

      # Return body
      #
      # @return [nil]
      #
      # @api private
      #
      def body; end

    end

    # New asset responder 
    class New < self
      STATUS = Response::Status::OK

    private

      # Return headers
      #
      # @return [Hash]
      #
      # @api private
      #
      def headers
        super.merge('Content-Type' => content_type)
      end

      # Return body
      #
      # @return [String]
      #
      # @api private
      #
      def body
        asset.body
      end

    end
  end
end
