module Assets
  class Package
    include Concord.new(:repository, :contents)

    # Return rules for mime type
    #
    # @return [Enumerable<Rule>]
    #
    # @api private
    #
    def mime(mime)
      contents.fetch(mime, [])
    end

    # Return image rules
    #
    # @return [Enumerable<Rule>]
    #
    # @api private
    #
    def images
      Mime::IMAGES.each_with_object([]) do |mime, images|
        images.concat(mime(mime))
      end
    end

    class Builder

      # Run builder 
      #
      # @param [String] directory
      #
      # @return [Package]
      #
      # @api private
      #
      def self.run(directory)
        repository = Repository::Directory.new(directory)
        builder = new(repository)
        yield builder
        Package.new(repository, builder.contents)
      end

      # Initialize object
      #
      # @param [Repository] repository
      #
      # @return [undefined]
      #
      # @api private
      #
      def initialize(repository)
        @repository = repository
        @contents = Hash.new { |hash, key| hash[key] = [] }
      end

      # Return contents
      #
      # @return [Hash]
      #
      # @api private
      #
      attr_reader :contents

      # Return repository
      #
      # @return [Repository]
      #
      # @api private
      #
      attr_reader :repository

      # Add compile
      #
      # @param [String] name
      #
      # @return [self]
      #
      # @api private
      #
      def compile(name)
        append(repository.compile(name))
      end

      # Add static file
      #
      # @param [String] name
      #
      # @return [self]
      #
      # @api private
      #
      def file(name)
        append(repository.file(name))
      end

      # Perform glob
      #
      # @param [String] pattern
      #
      # @return [Enumerable<String>]
      #
      # @api private
      #
      def glob(pattern)
        repository.glob(pattern)
      end

      # Append rule
      #
      # @param [Rule] rule
      #
      # @return [self]
      #
      # @api private
      #
      def append(rule)
        @contents[rule.mime] << rule
        self
      end
    end
  end
end

