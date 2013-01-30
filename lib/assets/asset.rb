module Assets

  # Abstract base class for asset
  class Asset
    include Adamantium, Anima.new(:name, :mime, :created_at, :size, :sha1, :body)

    # Test if asset was fresh at specific point of time
    #
    # @param [Time] time
    #
    # @return [true]
    #   if asset is fresh at time
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def fresh_at?(time)
      time >= created_at
    end

  end
end
