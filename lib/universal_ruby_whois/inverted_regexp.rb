module MattLightner

  #= Inverted Regular Expressions
  # Gives the ability to invert a regular expression so that running a match against it
  # will yield a true result when it does NOT match the target string.
  module InvertedRegexp

    def self.included(base)
      base.send(:include, MattLightner::InvertedRegexp::RegexpInstanceMethods)
    end

    module RegexpInstanceMethods
      # Invert this regular expression.
      def invert!
        @inverted = true
        self
      end

      # Uninvert this regular expression.
      def uninvert!
        @inverted = false
        self
      end

      def set_inverted(value = true)
        @inverted = (value) ? true : false
      end

      # Is this an inverted regular expression?
      def inverted?
        @inverted rescue false
      end

      def match_with_inversion(*args, &block)
        result = self.match(*args, &block)
        if @inverted
          result.nil? ? true : false
        else
          result
        end
      end
    end
  end
end
