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
    end

    def show
      @adoption = Adoption.find(params[:id])
      authorize @adoption
      render_success(data: @adoption)
    end

    def create
      adopter = get_user
      @adoption = AdoptionService::CreateAdoption.execute(adopter, params[:pet_id])
      render_success(data: @adoption)
    end

    def update
      @adoption = Adoption.find(params[:id])
      if @adoption.update(adoption_params)
        render_success(data: @adoption)
      else
        render_error(:unprocessable_entity, object: @adoption)
      end
    end

    def destroy
      @adoption = Adoption.find(params[:id])
      raise AdoptionErrors::AdoptionOnDestroyError unless @adoption.destroy
      render_success(data: @adoption)
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
