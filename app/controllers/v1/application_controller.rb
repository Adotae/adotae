# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::API
    include Formatters::ResponseFormatter
    include ErrorsHelper

    before_action :authenticate_and_set_user_or_admin_user

    # Error handling
    rescue_from ApiErrors::BaseError, with: :handle_error

    private

    def pundit_user
      @current_user || @current_admin_user
    end

    def handle_error(error)
      render_error(error.status, message: error.message)
    end
  end
end
