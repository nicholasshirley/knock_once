module KnockOnce
  class ApplicationController < ActionController::API
    include Knock::Authenticable
    require_dependency '../../lib/knock_once/configuration'
  end
end
