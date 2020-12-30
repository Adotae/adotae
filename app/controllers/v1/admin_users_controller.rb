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
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.admin_user.not_found"))
    end

    def me
      render_success(data: @current_admin_user)
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)
      if @admin_user.save
        render_success(data: @admin_user)
      else
        render_error(:unprocessable_entity, object: @admin_user)
      end
    end

    def update
      @admin_user = AdminUser.find(params[:id])
      if @admin_user.update(admin_user_params)
        render_success(data: @admin_user)
      else
        render_error(:unprocessable_entity, object: @admin_user)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.admin_user.not_found"))
    end

    def destroy
      @admin_user = AdminUser.find(params[:id])
      if @admin_user.destroy
        render_success(data: @admin_user)
      else
        render_error(:bad_request, message: I18n.t("adotae.errors.admin_user.on_destroy"))
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.admin_user.not_found"))
    end

    private

    def admin_user_params
      params.permit(:name, :email, :password)
    end

    def authorize_user
      authorize AdminUser
    end
  end
end
