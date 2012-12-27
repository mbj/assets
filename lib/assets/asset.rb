module Assets

  # Abstract base class for asset
  class Asset
    include Adamantium, AbstractType, Equalizer.new(:sha1)

    # Packaged asset
    class Packaged < self
      include Adamantium, Anima.new(:logical, :content_type, :size, :uri, :sha1)
    end

    # Dynamic asset
    class Dynamic < self
      def content_type; self.class::CONTENT_TYPE; end

      # Compiled asset
      class Compiled < self
        include AbstractType

        attr_reader :body

        def initialize(body)
          @body = body.dup.freeze
        end

        def sha1
          Digest::SHA1.hexdigest(body)
        end
        memoize :sha1

        # Return dynamic compiled css asset
        class CSS < self
          CONTENT_TYPE = 'text/css; charset=UTF-8'.freeze
        end

        # Return dynamic compiled javascript asset
        class Javascript < self
          CONTENT_TYPE = 'application/javascript'.freeze
        end
      end

      # Asset read from file
      class File < self
        include Composition.new(:path)

        # Return body
        #
        # @return [String]
        #
        # @api private
        #
        def body
          ::File.open(path)
        end

        # Return sha1 hexdigest
        #
        # @return [String]
        #
        # @api private
        #
        def sha1
          Digest::SHA1.file(path).hexdigest
        end
        memoize :sha1

        CONTENT_TYPES = {
          '.jpg'  => 'image/jpg',
          '.png'  => 'image/png',
          '.svg'  => 'image/svg',
          '.gif'  => 'image/gif',
          '.js'   => 'application/javascript',
          '.css'  => 'text/css',
        }.deep_freeze

        # Return content type
        #
        # @return [String]
        #
        # @api private
        #
        def content_type
          CONTENT_TYPES.fetch(::File.extname(path))
        end
        memoize :content_type
      end
    end
  end
end
