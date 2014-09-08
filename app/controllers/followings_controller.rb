class FollowingsController < AuthenticatedController
  skip_before_action :verify_authenticity_token, only: [:create, :delete  ]
  include FollowingsConcern
end
