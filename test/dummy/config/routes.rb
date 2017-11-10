Rails.application.routes.draw do
  mount KnockOnce::Engine => "/knock_once"
end
