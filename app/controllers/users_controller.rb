class UsersController < ApplicationController

  def index
    @users = User.all
    render json: { users: @users }
  end

end