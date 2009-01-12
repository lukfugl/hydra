module Hydra
  module Router
    class Trie
      attr_reader :branches, :values

      def initialize
        @branches = {}
        @values = []
      end

      def store(string, value, parameters={})
        if identifier = string.scan(/^:[_a-z][_a-z0-9]*/i)[0]
          string.slice!(0, identifier.length)
          identifier.slice!(0, 1)
          identifier = identifier.intern
          if pattern = parameters[identifier]
            new_pattern = /(#{pattern})/
            parameters.delete(identifier)
            @branches[new_pattern] ||= Trie.new
            @branches[new_pattern].store(string, [ identifier, *value ], parameters)
          else
            raise "no pattern specified for :#{identifier}"
          end
        elsif string.empty?
          @values << (Array === value ? value.reverse : [value])
        else
          key = /#{string.slice!(0, 1)}/
          @branches[key] ||= Trie.new
          @branches[key].store(string, value, parameters)
        end
      end

      def compress
        keys = @branches.keys
        keys.each do |key1|
          branch = @branches[key1]

          # compress sub-branches first
          branch.compress

          # if a branch off a character consists of a trie with only one key
          # and no values, and that key is another string, then collapse the
          # two into one string
          next unless branch.values.empty?
          next if branch.branches.size > 1

          key2 = branch.branches.keys.first
          value = branch.branches.values.first

          new_key = /#{key1}#{key2}/
          @branches[new_key] = value
          @branches.delete(key1)
        end
      end

      def recognize(string, *parameters)
      end

      def dump(indent="")
        @values.each do |value|
          puts "#{indent}#{value.inspect}"
        end
        @branches.each do |key,branch|
          puts "#{indent}#{key.inspect}:"
          branch.dump(indent + "  ")
        end
      end
    end
  end
end
