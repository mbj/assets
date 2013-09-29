module Assets
  class Environment
    # Static enviornment with precompiled assets
    class Static < self
      include Concord.new(:assets)

      # Return index
      #
      # @return [Hash]
      #
      # @api private
      #
      def index
        assets.each_with_object({}) do |asset, index|
          index[asset.name]=asset
        end
      end

      # Return asset
      #
      # @param [String] name
      #   name of asset
      #
      # @return [Asset]
      #   if found
      #
      # @return [nil]
      #   otherwise
      #
      # @api private
      #
      def get(name)
        index[name]
      end

    end # Static
  end # Environment
end # Assets
