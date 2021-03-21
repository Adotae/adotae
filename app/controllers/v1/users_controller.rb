# frozen_string_literal: true

module V1
  class UsersController < ApplicationController
    before_action :authorize_user

    def index
      @users = User.all
      render_success(data: @users)
    end

    def show
      @user = User.find(params[:id])
      render_success(data: @user)
    end

    def me
      render_success(data: @current_user)
    end

    def create
      @user = User.create!(user_params)
      render_success(data: @user)
    end

    def update
      @user = User.find(params[:id])
      @user.update!(user_params)
      render_success(data: @user)
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy!
      render_success(data: @user)
    end

    def profile
      data = {
        name: @current_user.name,
        about: "Amiga dos animais",
        location: "São Bernardo do Campo, São Paulo",
        photo: "",
        adoption_count: 1,
        donation_count: 2
      }
      render_success(data: data)
    end

    private

    def user_params
      params.permit(:name, :email, :phone, :password, :cpf, :cnpj)
    end

    def authorize_user
      authorize User
    end
  end
end
