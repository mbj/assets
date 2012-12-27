module Assets

  # Abstract base class for rules
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

end
