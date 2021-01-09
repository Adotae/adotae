module ApiErrors::DonationErrors
  class DonationOnDestroyError < BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.donation.on_destroy")
    end
  end
end