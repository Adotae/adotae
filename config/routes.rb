# frozen_string_literal: true

Rails.application.routes.draw do
  # Setup api guard routes for user
  api_guard_scope "users" do
    post "account/login" => "api_guard/authentication#create"
    delete "account/logout" => "api_guard/authentication#destroy"
    post "account/create" => "account/registration#create"
    delete "account/delete" => "api_guard/registration#destroy"
    patch "account/passwords" => "api_guard/passwords#update"
    post "account/tokens" => "api_guard/tokens#create"
  end

  # Setup api guard routes for admin
  api_guard_scope "admin_users" do
    post "admin/login" => "api_guard/authentication#create"
    delete "admin/logout" => "api_guard/authentication#destroy"
    patch "admin/passwords" => "api_guard/passwords#update"
    post "admin/tokens" => "api_guard/tokens#create"
  end

  api_version(
    module: "V1",
    header: {
      name: "Accept",
      value: "application/vnd.adotae.v1+json"
    },
    default: true
  ) do
    resources :users do
      get :me, on: :collection
    end

    resources :admin_users, path: 'admins' do
      get :me, on: :collection
    end

    resources :pets do
      get :around, on: :collection
      get :favorites, on: :collection
    end

    resources :adoptions
    resources :donations
  end
end
