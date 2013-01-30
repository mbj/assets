module Assets
  class Mime
    include Adamantium, Composition.new(:extname, :content_type)

    REGISTRY = {}

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

    JPG  = new('.jpg',  'image/jpg')
    ICO  = new('.ico',  'image/vnd.microsoft.icon')
    PNG  = new('.png',  'image/png')
    GID  = new('.gif',  'image/gif')
    SVG  = new('.scg',  'image/svg')
    TXT  = new('.txt',  'text/plain; charset=UTF-8')
    CSS  = new('.css',  'text/css; charset=UTF-8')
    JS   = new('.js',   'application/javascript')
    SASS = new('.sass', 'text/plain; charset=UTF-8')
    HTML = new('.html', 'text/html; charset=UTF-8')

    REGISTRY.freeze
  end
end
