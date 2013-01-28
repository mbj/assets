module Assets
  class Rule

    # Rule that concatenates assets from other rules
    class Concat < self
      include Composition.new(:name, :mime, :rules)

      # Instantiate object
      #
      # @param [String] name
      # @param [Enumerable<Rule>] rules
      #
      # @api private
      #
      def self.new(name, rules)
        mime = detect_mime(rules)
        super(name, mime, rules)
      end

      # Build concat rules
      #
      # @param [String] name
      #
      # @return [Rule::Concat]
      #
      def self.build(name, *rules)
        new(name, rules)
      end

      # Return body
      #
      # @return [String]
      #
      # @api private
      #
      def body
        rules.map(&:body).join
      end

      # Detect mime type
      #
      # @param [Rules] rules
      #
      # @return [Mime]
      #
      # @api private
      #
      def self.detect_mime(rules)
        raise "#{self.class.name} cannot work on empty rules" if rules.empty?

        mime = rules.first.mime

        unless rules.all? { |rule| rule.mime == mime }
          raise 'Rules do not share mime type!'
        end

        mime
      end

    end
  end
end
