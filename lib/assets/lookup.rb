module Asset

  # Assed lookup method object
  class Lookup
    include Adamantium, Composition.new(:environment, :logical), MethodObject.new(:asset)

    # Return asset
    #
    # @return [Asset]
    #
    # @api private
    #
    def asset
      if exist?
        Asset::Dynamic::File.new(path)
      else
        rule.asset
      end
    end
    memoize :asset

  private

    # Return extension name
    #
    # @return [String]
    #
    # @api private
    #
    def extname
      ::File.extname(logical)
    end
    memoize :extname

    # Return rule
    #
    # @return [Rule]
    #
    # @api private
    #
    def rule
      environment.rule(logical)
    end

    # Test if file exists
    #
    # @return [true]
    #   if file exists
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def exist?
      ::File.exist?(path)
    end

    # Return asset path
    #
    # @return [String]
    #
    # @api private
    #
    def path
      environment.path(logical)
    end
    memoize :path
  end
end
