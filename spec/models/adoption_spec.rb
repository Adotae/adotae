require 'rails_helper'

RSpec.describe Adoption, type: :model do
  
  context "validates adoption status" do
    let!(:adoption) { create(:adoption) }

    it "is valid" do
      adoption.status = "incomplete"
      expect(adoption).to be_valid
    end

    it "is not valid" do
      adoption = Adoption.new(status: "complete")
      expect(adoption).to_not be_valid
    end

    it "returns error message when status is nil" do
      adoption.status = nil
      adoption.valid?
      expect(adoption.errors[:status]).to include(
        I18n.t("activerecord.errors.models.adoption.attributes.status.blank"))
    end

    it "returns error message when status is empty" do
      adoption.status = ""
      adoption.valid?
      expect(adoption.errors[:status]).to include(
        I18n.t("activerecord.errors.models.adoption.attributes.status.blank"))
    end

    it "returns error message when status is invalid on update" do
      adoption.status = "unknown_status"
      adoption.valid?
      expect(adoption.errors[:status]).to include(
        I18n.t("activerecord.errors.models.adoption.attributes.status.invalid"))
    end
  end

  context "validates adoption completed_at" do

    it "is valid" do
      # :adoption doesn't set completed_at
      adoption = create(:adoption)
      expect(adoption).to be_valid
    end

    it "is not valid" do
      adoption = build(:adoption_with_completed_at)
      expect(adoption).to_not be_valid
    end

    it "returns error message when completed_at is present on create" do
      adoption = build(:adoption_with_completed_at)
      adoption.valid?
      expect(adoption.errors[:completed_at]).to include(
        I18n.t("activerecord.errors.models.adoption.attributes.completed_at.present"))
    end
  end
end
