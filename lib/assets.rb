require 'abstract_class'
require 'descendants_tracker'
require 'adamantium'
require 'equalizer'
require 'ice_nine'
require 'ice_nine/core_ext/object'

module Assets
  class Asset
    include Adamantium, AbstractType, Equalizer.new(:sha1)

    class Packaged
      include Adamantium, Anima

      attribute :logical
      attribute :content_type
      attribute :size
      attribute :uri

      include Equalizer.new(attribute_set.map(&:name))
    end

    class Dynamic < self
      def content_type; self.class::CONTENT_TYPE; end

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

        class CSS < self
          CONTENT_TYPE = 'text/css; charset=UTF-8'.freeze
        end

        class Javascript < self
          CONTENT_TYPE = 'application/javascript'.freeze
        end
      end

      class File < self
        attr_reader :path
        private :path

        def initialize(path)
          @path = path
        end

        def body
          ::File.open(path)
        end

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

        def content_type
          CONTENT_TYPES.fetch(::File.extname(path))
        end
        memoize :content_type
      end
    end
  end

  class MethodObject < ::Module
    include Adamantium, Equalizer.new(:method_name)

    attr_reader :method_name

    def initialize(method_name)
      @method_name = method_name
    end

    def included(descendant)
      super

      descendant.extend(class_methods)
    end

  private

    def class_methods
      Module.new do
        define_method(:run) do |*args|
          new(*args).send(@method_name)
        end
      end
    end
  end

  class Rule 
    include Adamantium, AbstractType, Equalizer.new(:logical)

    attr_reader :source
    private :source


    abstract_method :compiled

    class Static < self
      def initialize(asset)
        @asset = asset
      end

      attr_reader :asset
    end

    class Compile
      def asset
        asset_klass.new(compiled)
      end

      def asset_klass
        self.class::ASSET
      end

      def initialize(logical, source)
        @logical, @source = logical.dup.freeze, source.dup.freeze
      end


      class Sass < self
        ASSET = Asset::Dynamic::Compiled::CSS

        def compiled
          ::Sass.compile_file(source)
        end
      end
    end
  end

  class Lookup
    include Adamantium, MethodObject.new(:asset)

    attr_reader :env, :logical

    def initialize(env, logical)
      @env, @logical = env, logical
    end

    def asset
      if exist?
        Asset::Dynamic::File.new(path)
      else
        rule.asset
      end
    end
    memoize :asset

  private

    def extname
      ::File.extname(logical)
    end
    memoize :extname

    def rule
      env.rule(logical)
    end

    def exist?
      ::File.exist?(path)
    end

    def path
      env.path(logical)
    end
    memoize :path
  end

  class Environment
    include Adamantium, AbstractType

    abstract_method :get

    class Static
      def initialize(assets)
        @index = {}
        assets.each do |asset|
          @index[asset.logical]=asset
        end
      end

      def get(logical)
        @index.fetch(logical)
      end
    end

    class Dynamic
      attr_reader :root
      private :root

      attr_reader :rules
      private :rules

      def initialize(root, rules = [])
        @root = root
        @rules = {}
        rules.each do |rule|
          @rules[rule.logical]=rule
        end
      end

      def path(logical)
        ::File.join(root, logical)
      end

      def rule(logical)
        @rules.fetch(logical)
      end

      def get(logical)
        Lookup.run(self, logical)
      end
    end
  end

  class Server
    include Adamantium, Equalizer.new(:environment, :prefix)

    attr_reader :environment
    attr_reader :prefix

    def initialize(environment, prefix = '')
      @environment = environment
      @prefix = Regexp.compile("\\A#{Regexp.escape(prefix)}")
    end

    def call(env)
      path_info = env.fetch('PATH_INFO').gsub(prefix, '')
      asset = environment.get(path_info)
      Response.build(200, {'Content-Type' => asset.content_type}, asset.body)
    end
  end
end
