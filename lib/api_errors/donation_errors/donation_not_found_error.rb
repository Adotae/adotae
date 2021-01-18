module ApiErrors::DonationErrors
  class DonationNotFoundError < ApiErrors::BaseError
    def status = :not_found
    def message = I18n.t("adotae.errors.donation.not_found")
  end
end
