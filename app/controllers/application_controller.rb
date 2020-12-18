class ApplicationController < ActionController::API
  before_action :authenticate_and_set_user
end