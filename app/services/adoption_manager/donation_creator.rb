# frozen_string_literals: true

module AdoptionManager
  class DonationCreator < BaseService
    
    def initialize(giver, pet_id)
      @giver = giver
      @pet = giver.pets.find(pet_id)
    end

    def call
      create_donation
    end

    private

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
