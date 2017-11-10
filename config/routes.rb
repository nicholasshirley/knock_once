KnockOnce::Engine.routes.draw do
  post 'user_token' => 'user_token#create'

  resource :users

  ## Password routes

  # password udpate (user knows current password)
  patch '/passwords', to: 'passwords#update'
  put '/passwords', to: 'passwords#update'

  # password reset routes (user doesn't know current password)
  post '/passwords/reset', to: 'passwords#create'
  patch '/passwords/reset', to: 'passwords#edit'
  put '/passwords/reset', to: 'passwords#edit'
  post 'passwords/validate', to: 'passwords#validate'
end
