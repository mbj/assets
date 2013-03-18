module Assets
  class Rule
    class Compile
      class Javascript

        # Compiler for sass
        class Coffescript < self
          handle(Mime::COFFEESCRIPT)

          # Return body
          #
          # @return [String]
          #
          # @api private
          #
          def body
            ::CoffeeScript.compile(file.body)
          end

        end
      end
    end
  end
end
