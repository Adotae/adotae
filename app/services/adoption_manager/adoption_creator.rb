# frozen_string_literals: true

module AdoptionManager
  class AdoptionCreator < BaseService

    def initialize(adopter, pet_id)
      @adopter = adopter
      @pet = Pet.find(pet_id)
    end

    def call
      create_adoption
    end

    private

    def create_adoption
      raise PetErrors::PetCantBeAdoptedError unless @pet.can_be_adopted?
      raise AdoptionErrors::PetOwnerCantBeAdopterError unless @pet.user_id != @adopter.id

      @adoption = @pet.adoptions.incomplete.last

      Adoption.transaction do
        @adoption.update!(adopter_id: @adopter.id)
        @pet.update!(can_be_adopted: false)
      end

      # TODO: raise error if cannot update
      # raise AdoptionErrors::CantCreateAdoptionError unless @adoption.persisted?

      @adoption
    end
  end
end
