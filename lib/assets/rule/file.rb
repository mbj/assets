module Assets
  class Rule
    class File < self
      include Composition.new(:name, :path)

      # Return extname
      #
      # @return [String]
      #
      # @api private
      #
      def extname
        ::File.extname(path)
      end
      memoize :extname

      # Return body of asset
      #
      # @return [String]
      #
      # @api private
      #
      def body
        ::File.read(path)
      end

      # Return mime type
      #
      # @return [Mime]
      #
      # @api private
      #
      def mime
        Mime.extname(extname)
      end
      memoize :mime

      # Return modification time
      #
      # @return [Time]
      #
      # @api private
      #
      def updated_at
        ::File.mtime(path)
      end
    end
  end
end
