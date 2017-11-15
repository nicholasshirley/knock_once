module KnockOnce
  class ApplicationController < ActionController::API
    include Knock::Authenticable
    require_dependency '../../models/knock_once/configuration'
  end
end
