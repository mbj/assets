module Assets

  # Abstract base class for asset
  class Asset
    include Adamantium, Anima.new(:name, :mime, :created_at, :size, :sha1, :body)
  end
end
