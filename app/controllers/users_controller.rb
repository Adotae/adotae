class UsersController < ApplicationController

  def index
    @users = User.all
    render_success(data: @users)
  end

  def show
    @user = User.find(params[:id])
    render_success(data: @user)
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render_success(data: @user)
    else
      render_error(:unprocessable_entity, object: @user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render_success(data: @user)
    else
      render_error(:unprocessable_entity, object: @user)
    end
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    if @user.destroyed?
      render_success(data: @user)
    else
      render_error(:bad_request, message: I18n.t("adotae.errors.user.on_destroy"))
    end
  rescue ActiveRecord::RecordNotFound
    render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password)
  end

end