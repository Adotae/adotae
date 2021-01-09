# frozen_string_literal: true

module V1
  class PetsController < ApplicationController
    before_action :authorize_user, only: [:index, :create]

    def index
      if @current_admin_user
        user_id = params[:user]
        render_success(data: User.find(user_id).pets) if user_id
        render_success(data: Pet.all) unless user_id
      else
        render_success(data: @current_user.pets)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
    end

    def show
      @pet = Pet.find(params[:id])
      authorize @pet
      render_success(data: @pet)
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.pet.not_found"))
    end

    def create
      @pet = Pet.new(pet_params)

      if @current_admin_user
        render_error(
          :unprocessable_entity,
          message: "É necessário o id do usuário"
        ) and return if params[:user_id].blank?
        
        @pet.user = User.find(params[:user_id])
      else
        @pet.user = @current_user
      end

      if @pet.save
        render_success(data: @pet)
      else
        render_error(:unprocessable_entity, object: @pet)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
    end

    def update
      @pet = Pet.find(params[:id])
      authorize @pet
      if @pet.update(pet_params)
        render_success(data: @pet)
      else
        render_error(:unprocessable_entity, object: @pet)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.pet.not_found"))
    end

    def destroy
      @pet = Pet.find(params[:id])
      authorize @pet
      if @pet.destroy
        render_success(data: @pet)
      else
        render_error(:bad_request, message: I18n.t("adotae.errors.pet.on_destroy"))
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.pet.not_found"))
    end

    def around
      # GET /pets/around -> retorna os pets para adoção nos arredores do usuário logado
      # GET /pets/around/1 -> retorna os pets para adoção nos arredores do usuário de id 1 [admin]
    end

    def favorites
      if @current_admin_user
        user_id = params[:user]
        render_success(data: User.find(user_id).favorited_pets) if user_id
        render_success(data: []) unless user_id
      else
        render_success(data: @current_user.favorited_pets)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
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
        :photos,
        :description
      )
    end

    def authorize_user
      authorize Pet
    end
  end
end
