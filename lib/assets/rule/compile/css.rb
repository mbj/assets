module Assets
  class Rule
    class Compile
      # Abstract base class for compilers that compile to css
      class CSS < self

        MIME = Mime::CSS

        # Compiler for sass
        class SASS < self
          handle(Mime::SASS)

          # Return body
          #
          # @return [String]
          #
          # @api private
          #
          def body
            ::Sass.compile_file(file.path.to_s)
          end

        end

      end
    end
  end
end
