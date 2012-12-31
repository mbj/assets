module Assets
  class Mime
    include Adamantium, Composition.new(:extname, :content_type)

    def self.registry
      @registry ||= {}
    end

    def self.extname(extname)
      registry.fetch(extname)
    end

    private_class_method :registry

    def self.new(*)
      instance = super
      registry[instance.extname]=instance
      instance
    end

    JPG  = new('.jpg',  'image/jpg')
    PNG  = new('.png',  'image/png')
    GID  = new('.gif',  'image/gif')
    SVG  = new('.scg',  'image/svg')
    TXT  = new('.txt',  'text/plain; charset=UTF-8')
    CSS  = new('.css',  'text/css; charset=UTF-8')
    JS   = new('.js',   'application/javascript')
    SASS = new('.sass', 'text/plain; charset=UTF-8')
    HTML = new('.html', 'text/html; charset=UTF-8')
  end
end
