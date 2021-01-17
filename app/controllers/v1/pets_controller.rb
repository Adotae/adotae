# frozen_string_literal: true

module V1
  class PetsController < ApplicationController
    before_action :authorize_user, only: [:index, :create]
    before_action :map_pet_photos, only: [:create, :update]
    before_action :set_pet, only: [:show, :update, :destroy]

    before_action -> { select_user(need_user: false) }, only: [:index]
    before_action -> { select_user(need_user: true) },  only: [:create, :favorites]

    def index
      render_success(data: @user.pets) if @user
      render_success(data: Pet.all) unless @user
    end

    def show
      authorize @pet
      render_success(data: @pet)
    end

    def create
      @pet = Pet.new(pet_params).tap{ |pet|
        pet.user = @user
        pet.save!
      }
      render_success(data: @pet)
    end

    def update
      authorize @pet
      @pet.update!(pet_params)
      render_success(data: @pet)
    end

    def destroy
      @pet = Pet.find(params[:id])
      authorize @pet
      @pet.destroy!
      render_success(data: @pet)
    end

    def around
      # GET /pets/around -> retorna os pets para adoção nos arredores do usuário logado
      # GET /pets/around/1 -> retorna os pets para adoção nos arredores do usuário de id 1 [admin]
    end

    def favorites
      render_success(data: @user.favorited_pets)
    end

    private

    def pet_params
      params.permit(
        :name,
        :kind,
        :breed,
        :gender,
        :age,
        :height,
        :weight,
        :neutered,
        :dewormed,
        :vaccinated,
        :description,
        :photos => []
      )
    end

    def map_pet_photos
      if params[:photos].present?
        params[:photos] = params[:photos].values
      end
    end

    def set_pet
      @pet = Pet.find(params[:id])
    end

    def select_user(need_user)
      if @current_admin_user
        user_id = params[:user] || params[:user_id]
        raise UserErrors::MissingUserIdError if need_user && !user_id
        @user = User.find(user_id) if user_id
      else
        @user = @current_user
      end
    end

    def authorize_user
      authorize Pet
    end
  end
end
