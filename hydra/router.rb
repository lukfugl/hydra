require 'hydra/router/trie'

module Hydra
  module Router
    class << self
      attr_reader :routes

      def register(uri, resource, parameters={})
        @routes ||= Trie.new
        @routes.store(uri, resource, parameters)
        @routes.compress
      end
    end
  end
end
