module Assets

  # Abstract base class for asset repositories
  class Repository

    # Physical directory repository
    class Directory
      include Composition.new(:root)

      # Build a file rule
      #
      # @param [#to_s] name
      #
      # @return [Rule::File]
      #
      # @api private
      #
      def file(name)
        Rule::File.new(name.to_s, path(name))
      end

      # Return path for name
      #
      # @param [String] name
      #
      # @return [Pathname]
      #
      # @api private
      #
      def path(name)
        root.join(name)
      end

      # Build a compile rule
      #
      # @return [Rule::Compile::Sass]
      #
      # @api private
      #
      def compile(name)
        Rule::Compile.build(file(name))
      end

    end
  end
end
