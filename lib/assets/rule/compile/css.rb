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
            binary(::Sass.compile(input.body, :syntax => :sass))
          end

        end # Sass

        # Compiler for sass in scss flavor
        class Scss < self
          handle(Mime::SCSS)

          # Return body
          #
          # @return [String]
          #
          # @api private
          #
          def body
            binary(::Sass.compile(input.body, :syntax => :scss))
          end

        end # Scss

      end # Css
    end # Compile
  end # Rule
end # Assets
