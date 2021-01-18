require 'rails_helper'

RSpec.describe Pet, type: :model do
  
  context "validates pet name" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.name = "Test Test Test"
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.name = nil
      expect(pet).to_not be_valid
    end

    it "returns error message when name is nil" do
      pet.name = nil
      pet.valid?
      expect(pet.errors[:name]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.name.blank"))
    end

    it "returns error message when name is empty" do
      pet.name = ""
      pet.valid?
      expect(pet.errors[:name]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.name.blank"))
    end

    it "returns error message when name is too long" do
      pet.name = "A" * 256
      pet.valid?
      expect(pet.errors[:name]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.name.too_long"))
    end
  end

  context "validates pet kind" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.kind = "dog"
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.kind = "unknown_kind"
      expect(pet).to_not be_valid
    end

    it "returns error message when kind is nil" do
      pet.kind = nil
      pet.valid?
      expect(pet.errors[:kind]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.kind.blank"))
    end

    it "returns error message when kind is empty" do
      pet.kind = ""
      pet.valid?
      expect(pet.errors[:kind]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.kind.blank"))
    end

    it "returns error message when kind is not valid" do
      pet.kind = "unknown_kind"
      pet.valid?
      expect(pet.errors[:kind]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.kind.invalid"))
    end
  end

  context "validates pet breed" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.breed = "shitzu"
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.breed = "unknown_breed"
      expect(pet).to_not be_valid
    end

    it "returns error message when breed is nil" do
      pet.breed = nil
      pet.valid?
      expect(pet.errors[:breed]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.breed.blank"))
    end

    it "returns error message when breed is empty" do
      pet.breed = ""
      pet.valid?
      expect(pet.errors[:breed]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.breed.blank"))
    end

    it "returns error message when breed is not valid" do
      pet.breed = "unknown_breed"
      pet.valid?
      expect(pet.errors[:breed]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.breed.invalid"))
    end
  end

  context "validates pet gender" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.gender = "female"
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.gender = "unknown_gender"
      expect(pet).to_not be_valid
    end

    it "returns error message when gender is nil" do
      pet.gender = nil
      pet.valid?
      expect(pet.errors[:gender]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.gender.blank"))
    end

    it "returns error message when gender is empty" do
      pet.gender = ""
      pet.valid?
      expect(pet.errors[:gender]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.gender.blank"))
    end

    it "returns error message when gender is not valid" do
      pet.gender = "unknown_gender"
      pet.valid?
      expect(pet.errors[:gender]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.gender.invalid"))
    end
  end

  context "validates pet age" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.age = 5
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.age = 101
      expect(pet).to_not be_valid
    end

    it "returns error message when age is nil" do
      pet.age = nil
      pet.valid?
      expect(pet.errors[:age]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.age.blank"))
    end

    it "returns error message when age is less than expected" do
      pet.age = 0
      pet.valid?
      expect(pet.errors[:age]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.age.greater_than", count: 0))
    end

    it "returns error message when age is greater than expected" do
      pet.age = 101
      pet.valid?
      expect(pet.errors[:age]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.age.less_than_or_equal_to", count: 100))
    end

    it "returns error message when age is not integer" do
      pet.age = 5.1
      pet.valid?
      expect(pet.errors[:age]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.age.not_an_integer"))
    end
  end

  context "validates pet height" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.height = 60 # in cm
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.height = 501 # in cm
      expect(pet).to_not be_valid
    end

    it "returns error message when height is nil" do
      pet.height = nil
      pet.valid?
      expect(pet.errors[:height]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.height.blank"))
    end

    it "returns error message when height is less than expected" do
      pet.height = 0
      pet.valid?
      expect(pet.errors[:height]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.height.greater_than", count: 0))
    end

    it "returns error message when height is greater than expected" do
      pet.height = 501 # in cm
      pet.valid?
      expect(pet.errors[:height]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.height.less_than_or_equal_to", count: 500))
    end

    it "returns error message when height is not integer" do
      pet.height = 60.1
      pet.valid?
      expect(pet.errors[:height]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.height.not_an_integer"))
    end
  end

  context "validates pet weight" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.weight = 20000 # in grams
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.weight = 500001 # in grams
      expect(pet).to_not be_valid
    end

    it "returns error message when weight is nil" do
      pet.weight = nil
      pet.valid?
      expect(pet.errors[:weight]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.weight.blank"))
    end

    it "returns error message when weight is less than expected" do
      pet.weight = 0
      pet.valid?
      expect(pet.errors[:weight]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.weight.greater_than", count: 0))
    end

    it "returns error message when weight is greater than expected" do
      pet.weight = 500001 # in grams
      pet.valid?
      expect(pet.errors[:weight]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.weight.less_than_or_equal_to", count: 500000))
    end

    it "returns error message when weight is not integer" do
      pet.weight = 5.1
      pet.valid?
      expect(pet.errors[:weight]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.weight.not_an_integer"))
    end
  end

  context "validates pet neutered flag" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.neutered = true
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.neutered = nil
      expect(pet).to_not be_valid
    end

    it "returns error message when neutered is nil" do
      pet.neutered = nil
      pet.valid?
      expect(pet.errors[:neutered]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.neutered.inclusion"))
    end
  end

  context "validates pet dewormed flag" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.dewormed = true
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.dewormed = nil
      expect(pet).to_not be_valid
    end

    it "returns error message when dewormed is nil" do
      pet.dewormed = nil
      pet.valid?
      expect(pet.errors[:dewormed]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.dewormed.inclusion"))
    end
  end

  context "validates pet vaccinated flag" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.vaccinated = true
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.vaccinated = nil
      expect(pet).to_not be_valid
    end

    it "returns error message when vaccinated is nil" do
      pet.vaccinated = nil
      pet.valid?
      expect(pet.errors[:vaccinated]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.vaccinated.inclusion"))
    end
  end

  context "validates pet photos" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.photos = [
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/01.jpg', 'image/jpeg')
      ]
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.photos = nil
      expect(pet).to_not be_valid
    end

    it "returns error message when photos is nil" do
      pet.photos = nil
      pet.valid?
      expect(pet.errors[:photos]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.photos.blank"))
    end

    it "returns error message when photos is empty" do
      pet.photos = []
      pet.valid?
      expect(pet.errors[:photos]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.photos.blank"))
    end

    it "returns error message when photos length is too short" do
      pet.photos = []
      pet.valid?
      expect(pet.errors[:photos]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.photos.too_short", count: 1))
    end

    it "returns error message when photos length is too long" do
      pet.photos = [
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/01.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/02.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/03.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/03.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/02.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/01.jpg', 'image/jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/photos/pet/02.jpg', 'image/jpeg'),
      ]
      pet.valid?
      expect(pet.errors[:photos]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.photos.too_long", count: 6))
    end

    it "returns photos urls" do
      expect(pet.photos_urls.size).to eq(pet.photos.size)
      expect(pet.photos_urls[0]).to eq(url_for(pet.photos[0]))
    end
  end

  context "validates pet description" do
    let!(:pet) { create(:pet) }

    it "is valid" do
      pet.description = "At least 10 caracters"
      expect(pet).to be_valid
    end

    it "is not valid" do
      pet.description = "Not valid"
      expect(pet).to_not be_valid
    end

    it "returns error message when description is too short" do
      pet.description = "Not valid"
      pet.valid?
      expect(pet.errors[:description]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.description.too_short", count: 10))
    end

    it "returns error message when description is too long" do
      pet.description = "A" * 1025
      pet.valid?
      expect(pet.errors[:description]).to include(
        I18n.t("activerecord.errors.models.pet.attributes.description.too_long", count: 1024))
    end
  end
end
