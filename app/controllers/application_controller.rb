class ApplicationController < ActionController::API
  include Pundit

  before_action :authenticate_and_set_user_or_admin_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def pundit_user
    @current_user || @current_admin_user
  end

  def user_not_authorized
    render_error(:forbidden, message: I18n.t('adotae.errors.authorization.unauthorized'))
  end
end