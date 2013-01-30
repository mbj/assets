module Assets
  class Rule
    class Compile
      # Abstract base class for compilers that compile to javascript
      class Javascript < self

        MIME = Mime::JAVASCRIPT

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
            ::CoffeeScript.compile(::File.read(file.path))
          end

        end

      end
    end
  end
end
