module ApiErrors::DonationErrors
  class DonationNotDestroyedError < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.donation.not_destroyed")
    end
  end
end