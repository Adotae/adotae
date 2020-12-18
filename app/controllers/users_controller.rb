class UsersController < ApplicationController
  before_action :authorized, only: [:index]

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
      token = encode_token({ user_id: @user.id })
      byebug
      render json: { user: @user, token: token }
    else
      render json: { error: "Invalid username or password" }
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password)
  end

end
