module ApiErrors::DonationErrors
  class CantCreateDonation < ApiErrors::BaseError
    def status
      :bad_request
    end

    def message
      I18n.t("adotae.errors.donation.cant_create")
    end
  end
end