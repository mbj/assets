module Assets
  # Asset builder
  class Builder

    # Run builder
    #
    # @param [String] name
    #
    # @return [Rule]
    #
    # @api private
    #
    def self.run(name)
      builder = new(name, Mime.from_name(name))
      yield builder
      Assets::Rule::Concat.new(name, builder.rules)
    end

    # Return rules
    #
    # @return [Enumerable<Rule>]
    #
    # @api private
    #
    attr_reader :rules

    # Initialize object
    #
    # @param [String] name
    # @param [Mime] mime
    #
    # @api private
    #
    # @return [undefined]
    #
    def initialize(name, mime)
      @name, @mime, @rules = name, mime, []
    end

    # Use pacakges
    #
    # @param [Enumerable<Package>] packages
    #
    # @return [self]
    #
    # @api private
    #
    def packages(packages)
      packages.each do |package|
        package(package)
      end
      self
    end

    # Use package
    #
    # @param [Assets::Package]
    #
    # @return [self]
    #
    # @api private
    #
    def package(package)
      package.mime(@mime).each do |rule|
        append(rule)
      end
      self
    end

    # Add rule
    #
    # @param [Rule]
    #
    # @return [self]
    #
    # @api private
    #
    def append(rule)
      unless rule.mime == @mime
        raise
      end

      @rules << rule

      self
    end
  end
end
