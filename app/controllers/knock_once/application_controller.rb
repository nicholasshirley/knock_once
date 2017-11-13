module KnockOnce
  class ApplicationController < ActionController::API
    include Knock::Authenticable
  end
end
