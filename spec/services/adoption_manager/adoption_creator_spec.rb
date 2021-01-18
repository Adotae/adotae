require 'rails_helper'

RSpec.describe AdoptionManager::AdoptionCreator do
  subject { AdoptionManager::AdoptionCreator }

  let!(:giver) { create(:user_with_donations) }
  let!(:adopter) { create(:user) }
  
  it "creates an adoption" do
    adoption = subject.new(adopter, giver.donations.first.pet_id).call
    expect(adoption).to be_valid
  end

  it "returns an error when pet owner tries to adopter" do
    creator = subject.new(giver, giver.donations.last.pet_id)
    expect {
      adoption = creator.call
      expect(adoption).to be_nil
    }.to raise_error(ApiErrors::AdoptionErrors::PetOwnerCantBeAdopterError)
  end
end
