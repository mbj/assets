module Assets

  # Rule evaluator
  class Evaluator
    include Adamantium, Concord.new(:rule)

    # Return asset
    #
    # @return [Asset]
    #
    # @api private
    #
    def asset
      rule = self.rule
      Asset.new(
        :name       => rule.name,
        :mime       => rule.mime,
        :created_at => Time.now,
        :body       => body,
        :size       => size,
        :sha1       => sha1
      )
    end

    # Return sha1 hexdigest of body
    #
    # @return [String]
    #
    # @api private
    #
    def sha1
      Digest::SHA1.hexdigest(body)
    end

    # Return body
    #
    # @return [String]
    #
    # @api private
    #
    def body
      rule.body
    end
    memoize :body

    # Return size in bytes
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def size
      body.bytesize
    end

    # Return mime
    #
    # @return [Mime]
    #
    # @api private
    #
    def mime
      rule.mime
    end

  end
end
