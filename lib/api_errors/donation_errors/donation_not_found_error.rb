module ApiErrors::DonationErrors
  class DonationNotFoundError < BaseError
    def status
      :not_found
    end

    def message
      I18n.t("adotae.errors.donation.not_found")
    end
  end
end