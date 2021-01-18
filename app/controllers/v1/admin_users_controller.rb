# frozen_string_literal: true

module V1
  class AdminUsersController < ApplicationController
    before_action :authorize_user

    def index
      @admin_users = AdminUser.all
      render_success(data: @admin_users)
    end

    def show
      @admin_user = AdminUser.find(params[:id])
      render_success(data: @admin_user)
    end

    def me
      render_success(data: @current_admin_user)
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)
      @admin_user.save!
      render_success(data: @admin_user)
    end

    def update
      @admin_user = AdminUser.find(params[:id])
      @admin_user.update!(admin_user_params)
      render_success(data: @admin_user)
    end

    def destroy
      @admin_user = AdminUser.find(params[:id])
      @admin_user.destroy!
      render_success(data: @admin_user)
    end

    private

    def admin_user_params
      params.permit(:name, :email, :password, :cpf)
    end

    def authorize_user
      authorize AdminUser
    end
  end
end
