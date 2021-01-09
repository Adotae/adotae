# frozen_string_literal: true

module V1
  class DonationsController < ApplicationController
    before_action :authorize_user, except: [:show]

    def index
      if @current_admin_user
        user_id = params[:user]
        render_success(data: User.find(user_id).donations) if user_id
        render_success(data: Adoption.all) unless user_id
      else
        render_success(data: @current_user.donations)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
    end

    def show
      @donation = Adoption.find(params[:id])
      authorize @donation
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.donation.not_found"))
    end

    def create
      if @current_admin_user
        render_error(
          :unprocessable_entity,
          message: "É necessário o id do usuário"
        ) and return if params[:user_id].blank?

        giver = User.find(params[:user_id])
      else
        giver = @current_user
      end

      ##### AdoptionManager::CreateDonation
      pet = giver.pets.find(params[:pet_id])
      
      @adoption = Adoption.new(
        pet_id: pet.id,
        giver_id: pet.user_id,
        status: 'incomplete'
      )

      if @adoption.save
        pet.update(can_be_adopted: true)
      end
      #####

      if @adoption.persisted?
        render_success(data: @adoption)
      else
        render_error(:unprocessable_entity, object: @adoption)
      end
    rescue ActiveRecord::RecordNotFound => e
      case e.model
      when User.name
        render_error(:not_found, message: I18n.t("adotae.errors.user.not_found"))
      when Pet.name
        render_error(:not_found, message: I18n.t("adotae.errors.pet.not_found"))
      end
    end

    def update
      @donation = Adoption.find(params[:id])
      if @donation.update(donation_params)
        render_success(data: @donation)
      else
        render_error(:unprocessable_entity, object: @donation)
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.donation.not_found"))
    end

    def destroy
      @donation = Adoption.find(params[:id])
      if @donation.destroy
        render_success(data: @donation)
      else
        render_error(:bad_request, message: I18n.t("adotae.errors.donation.on_destroy"))
      end
    rescue ActiveRecord::RecordNotFound
      render_error(:not_found, message: I18n.t("adotae.errors.donation.not_found"))
    end

    private

    def donation_params
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
