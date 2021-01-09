# frozen_string_literal: true

module V1
  class AdoptionsController < ApplicationController
    before_action :authorize_user, except: [:show]

    def index
      if @current_admin_user
        user_id = params[:user]
        render_success(data: User.find(user_id).adoptions) if user_id
        render_success(data: Adoption.all) unless user_id
      else
        render_success(data: @current_user.adoptions)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
    end

    def show
      @adoption = Adoption.find(params[:id])
      authorize @adoption
      render_success(data: @adoption)
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.adoption.not_found"))
    end

    def create
      if @current_admin_user
        render_error(
          :unprocessable_entity,
          message: "É necessário o id do usuário"
        ) and return if params[:user_id].blank?

        adopter = User.find(params[:user_id])
      else
        adopter = @current_user
      end

      ##### AdoptionManager::CreateAdoption
      pet = Pet.find(params[:pet_id])

      if pet.can_be_adopted?
        @adoption = Adoption.where(pet_id: pet.id).last
        @adoption.update(adopter_id: adopter.id)
        pet.update(can_be_adopted: false)
        render_success(data: @adoption)
      else
        render_error(:not_found, message: I18n.t("adotae.errors.pet.cant_be_adopted")) and return
      end
      #####

    rescue ActiveRecord::RecordNotFound => e
      case e.model
      when User.name
        render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
      when Pet.name
        render_error(:not_found, message: I18n.t("adotae.errors.pet.not_found"))
      end
    end

    def update
      @adoption = Adoption.find(params[:id])
      if @adoption.update(adoption_params)
        render_success(data: @adoption)
      else
        render_error(:unprocessable_entity, object: @adoption)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.adoption.not_found"))
    end

    def destroy
      @adoption = Adoption.find(params[:id])
      if @adoption.destroy
        render_success(data: @adoption)
      else
        render_error(:bad_request, message: I18n.t("adotae.errors.adoption.on_destroy"))
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.adoption.not_found"))
    end

    private

    def adoption_params
      params.permit(
        :pet_id,
        :giver_id,
        :adopter_id,
        :associate_id,
        :status
      )
    end

    def authorize_user
      authorize Adoption
    end
  end
end
