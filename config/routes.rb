Rails.application.routes.draw do
  
  # Setup api guard routes
  api_guard_scope 'users' do
    post 'account/login' => "api_guard/authentication#create"
    delete 'account/logout' => "api_guard/authentication#destroy"
    post 'account/create' => "account/registration#create"
    delete 'account/delete' => "api_guard/registration#destroy"
    patch 'account/passwords' => "api_guard/passwords#update"
    post 'account/tokens' => "api_guard/tokens#create"
  end

  resources :users
end
