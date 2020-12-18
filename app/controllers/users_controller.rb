class UsersController < ApplicationController

  def index
    @users = User.all
    render json: { users: @users }
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      render json: { user: @user }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render json: { user: @user }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password)
  end

end
