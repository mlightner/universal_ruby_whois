#require File.dirname(__FILE__) + '/string.rb'

module MattLightner

  module ExtendedRegexp

    def self.included(base)
      base.send(:include, MattLightner::ExtendedRegexp::InstanceMethods)
    end

    module InstanceMethods

      def interpolate(*args)
        if args.length > 1
          replacements = Hash[*args]
        elsif args.first.kind_of?(Hash)
          replacements = args.first
        else
          raise ArgumentError, "Must pass hash to interpolate."
        end

        string = self.source

        replacements.each do |key, value|
          if key.kind_of?(Regexp)
            string.gsub!(key, value.to_s)
          else
            string.gsub!(/#{self.class.escape(key)}/im, value.to_s)
          end
        end

        string = (self.source.to_s).interpolate(*args)
        self.class.new(string, self.options)
      end

      def new_options(option_string)
        options_list = []
        { :i => Regexp::IGNORECASE,
          :x => Regexp::EXTENDED,
          :m => Regexp::MULTILINE }.each_pair do |charcode, constant|
          options_list.push(constant) if option_string =~ /#{charcode.to_s}/i
        end

        self.class.new(self.source, options_list)
      end


      # == Inverted Regular Expressions
      # Gives the ability to invert a regular expression so that running a match against it
      # will yield a true result when it does NOT match the target string.
      #
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
