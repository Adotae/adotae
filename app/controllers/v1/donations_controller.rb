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
      authorize @donation
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
    end

    def create
      giver = get_user
      @donation = DonationService::CreateDonation.execute(giver, params[:pet_id])
      render_success(data: @donation)
    end

    def update
      @donation = Adoption.find(params[:id])
      if @donation.update(donation_params)
        render_success(data: @donation)
      else
        render_error(:unprocessable_entity, object: @donation)
      end
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
    end

    def destroy
      @donation = Adoption.find(params[:id])
      raise DonationErrors::DonationOnDestroyError unless @donation.destroy
      render_success(data: @donation)
    rescue ActiveRecord::RecordNotFound
      raise DonationErrors::DonationNotFoundError
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

    def get_user
      if @current_admin_user
        raise UserErrors::MissingUserIdError unless params[:user_id].present?
        User.find(params[:user_id])
      else
        @current_user
      end
    end

    def authorize_user
      authorize Adoption
    end
  end
end
