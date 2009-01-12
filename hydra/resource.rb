require 'hydra/router'

module Hydra
  class Resource
    class << self
      def uri(uri, parameters={})
        @uri = uri
        @parameters = parameters
        Hydra::Router.register(uri, self, @parameters)
      end
    end
  end
end
