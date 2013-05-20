module Assets
  class Rule
    # Rule that concatenates assets from other rules
    class Concat < self
      include Concord.new(:name, :mime, :rules)

      # Return name
      #
      # @return [String]
      #
      # @api private
      #
      attr_reader :name

      # Return mime
      #
      # @return [Mime]
      #
      # @api private
      #
      attr_reader :mime

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
      # @api private
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

      # Return updated_at
      #
      # @return [Time]
      #
      # @api private
      #
      def updated_at
        rules = self.rules
        time = rules.first.updated_at
        rules.each do |rule|
          updated_at = rule.updated_at
          if time < updated_at
            time = updated_at
          end
        end
        time
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
        raise "No mime type for empty rules" if rules.empty?

        mime = rules.first.mime

        unless rules.all? { |rule| rule.mime == mime }
          raise 'Rules do not share mime type!'
        end

        mime
      end

    end
  end
end
