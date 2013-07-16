module Assets
  class Mime
    include Adamantium, Concord.new(:extname, :content_type)

    REGISTRY = {}

    # Return extname
    #
    # @return [String]
    #
    # @api private
    #
    attr_reader :extname

    # Return content type
    #
    # @return [String]
    #
    # @api private
    #
    attr_reader :content_type

    # Return mime for extname
    #
    # @param [String] extname
    #
    # @return [Mime]
    #
    # @api private
    #
    def self.extname(extname)
      REGISTRY.fetch(extname)
    end

    # Return mime name
    #
    # @param [String] name
    #
    # @return [Mime]
    #
    # @api private
    #
    def self.from_name(name)
      extname(::File.extname(name))
    end

    # Instantiate object
    #
    # @return [Mime]
    #
    # @api private
    #
    def self.new(*)
      instance = super
      REGISTRY[instance.extname]=instance
      instance
    end

    private_class_method :new

    JPG          = new('.jpg',    'image/jpg'                               )
    ICO          = new('.ico',    'image/vnd.microsoft.icon'                )
    PNG          = new('.png',    'image/png'                               )
    GIF          = new('.gif',    'image/gif'                               )
    SVG          = new('.svg',    'image/svg'                               )
    PDF          = new('.pdf',    'application/pdf'                         )
    RUBY         = new('.rb',     'application/ruby'                        )
    TXT          = new('.txt',    'text/plain; charset=UTF-8'               )
    CSS          = new('.css',    'text/css; charset=UTF-8'                 )
    JAVASCRIPT   = new('.js',     'application/javascript; charset=UTF-8'   )
    COFFEESCRIPT = new('.coffee', 'application/coffeescript; charset=UTF-8' )
    SASS         = new('.sass',   'text/plain; charset=UTF-8'               )
    SCSS         = new('.scss',   'text/plain; charset=UTF-8'               )
    HTML         = new('.html',   'text/html; charset=UTF-8'                )
    WOFF         = new('.woff',   'application/font-woff'                   )

    IMAGES = [
      JPG, ICO, PNG, SVG, GIF
    ].freeze

    REGISTRY.freeze
  end
end
