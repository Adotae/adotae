# frozen_string_literals: true

module DonationService
  class CreateDonation < BaseService
    def self.execute(giver, pet_id)
      self.new(giver, pet_id).tap do |service|
        return service.create_donation
      end
    end

    def initialize(giver, pet_id)
      @giver = giver
      @pet = giver.pets.find(pet_id)
    end

    def create_donation
      raise PetErrors::PetCantBeDonatedError if @pet.in_adoption?

      @adoption = Adoption.new(
        pet_id: @pet.id,
        giver_id: @giver.id,
        status: 'incomplete'
      )

      Adoption.transaction do
        @adoption.save!
        @pet.update!(can_be_adopted: true)
      end

      raise DonationErrors::CantCreateDonationError unless @adoption.persisted?

      @adoption
    end
  end
end
