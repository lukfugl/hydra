require 'hydra'

module Resource
  class Posts < Hydra::Resource
    uri "/"
  end

  class Post < Hydra::Resource
    uri "/:slug",
      :slug => /[a-z-]+/i
  end

  class Comments < Hydra::Resource
    uri "/:slug/comments",
      :slug => /[a-z-]+/i
  end

  class Comment < Hydra::Resource
    uri "/:slug/comments/:id",
      :slug => /[a-z-]+/i,
      :id => /\d+/
  end
end

Hydra::Router.routes.dump
