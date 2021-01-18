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
    end

    def show
      @donation = Adoption.find(params[:id])
      authorize([:donation, @donation])
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
    end

    def create
      @donation = AdoptionManager::DonationCreator.call(user, params[:pet_id])
      render_success(data: @donation)
    end

    def update
      @donation = Adoption.find(params[:id])
      @donation.update!(donation_params)
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
    end

    def destroy
      @donation = Adoption.find(params[:id])
      @donation.destroy!
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
    rescue ActiveRecord::RecordNotDestroyed
      raise DonationErrors::DonationNotDestroyedError
    end

    private

    def donation_params
      params.permit(
        :pet_id,
        :giver_id,
        :adopter_id,
        :associate_id,
        :status,
        :completed_at
      )
    end

    def user
      if @current_admin_user
        raise UserErrors::MissingUserIdError if params[:user_id].blank?
        User.find(params[:user_id])
      else
        @current_user
      end
    end

    def authorize_user
      authorize([:donation, Adoption])
    end
  end
end
