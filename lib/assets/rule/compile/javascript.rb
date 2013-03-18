module Assets
  class Rule
    class Compile
      # Base class for compilers that compile to javascript
      class Javascript < self

        MIME = Mime::JAVASCRIPT

      end
    end
  end
end
