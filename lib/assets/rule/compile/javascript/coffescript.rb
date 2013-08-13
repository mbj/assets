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
            binary(::CoffeeScript.compile(input.body))
          end

        end # Coffeescript
      end # Javascript
    end # Compile
  end # Rule
end # Assets
