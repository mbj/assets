module Assets
  class Rule
    class Compile
      # Abstract base class for compilers that compile to css
      class Css < self

        MIME = Mime::CSS

        # Compiler for sass
        class Sass < self
          handle(Mime::SASS)

          # Return body
          #
          # @return [String]
          #
          # @api private
          #
          def body
            ::Sass.compile(input.body, :syntax => :sass)
          end

        end # Sass

      end # Css
    end # Compile
  end # Rule
end # Assets
