require 'rails_helper'

RSpec.describe User, type: :model do

  context "validates user name" do
    let!(:user) { create(:user) }

    it "is valid" do
      user.name = "Test Test Test"
      expect(user).to be_valid
    end

    it "is not valid" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "returns error message when name is nil" do
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include(I18n.t('activerecord.errors.models.user.attributes.name.blank'))
    end

    it "returns error message when name is empty" do
      user.name = ""
      user.valid?
      expect(user.errors[:name]).to include(I18n.t('activerecord.errors.models.user.attributes.name.blank'))
    end

    it "returns error message when name is too short" do
      user.name = "Ana"
      user.valid?
      expect(user.errors[:name]).to include(I18n.t('activerecord.errors.models.user.attributes.name.too_short'))
    end

    it "returns error message when name is too long" do
      user.name = "A" * 256
      user.valid?
      expect(user.errors[:name]).to include(I18n.t('activerecord.errors.models.user.attributes.name.too_long'))
    end
  end

  context "validates user email" do
    let!(:user) { create(:user) }

    it "is valid" do
      user.email = "test@adotae.com.br"
      expect(user).to be_valid
    end

    it "is not valid when nil" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is not valid when invalid format" do
      user.email = " test @adotaecom"
      expect(user).to_not be_valid
    end

    it "returns error message when email is nil" do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('activerecord.errors.models.user.attributes.email.blank'))
    end

    it "returns error message when email is empty" do
      user.email = ""
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('activerecord.errors.models.user.attributes.email.blank'))
    end

    it "returns error message when email is already in use" do
      user.save!
      another_user = User.new email: user.email
      another_user.valid?
      expect(another_user.errors[:email]).to include(I18n.t('activerecord.errors.models.user.attributes.email.taken'))
    end

    it "returns error message when email has invalid format" do
      user.email = "a test @adotaecom"
      user.valid?
      expect(user.errors[:email]).to include(I18n.t('activerecord.errors.models.user.attributes.email.invalid'))
    end
  end

  context "validates user phone" do
    let!(:user) { create(:user) }

    it "is valid" do
      user.phone = "(11) 90000-1111"
      expect(user).to be_valid
    end

    it "is not valid when invalid format" do
      user.phone = "11 9000-1111"
      expect(user).to_not be_valid
    end

    it "returns error message when phone is already in use" do
      user.save!
      another_user = User.new phone: user.phone
      another_user.valid?
      expect(another_user.errors[:phone]).to include(I18n.t('activerecord.errors.models.user.attributes.phone.taken'))
    end

    it "returns error message when phone has invalid format" do
      user.phone = "11 9000-1111"
      user.valid?
      expect(user.errors[:phone]).to include(I18n.t('activerecord.errors.models.user.attributes.phone.invalid'))
    end
  end

  context "validates user password" do
    let!(:user) { create(:user) }

    it "is valid" do
      user.password = "Aaaaaa@0"
      expect(user).to be_valid
    end

    it "is not valid when nil" do
      another_user = User.new password: nil
      expect(another_user).to_not be_valid
    end

    it "is not valid when invalid format" do
      user.password = "11 9000-1111"
      expect(user).to_not be_valid
    end

    it "returns error message when password is nil" do
      another_user = User.new password: nil
      another_user.valid?
      expect(another_user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.blank'))
    end

    it "returns error message when password is empty" do
      another_user = User.new password: ""
      another_user.valid?
      expect(another_user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.blank'))
    end

    it "returns error message when password is too short" do
      user.password = "test"
      user.valid?
      expect(user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.too_short'))
    end

    it "returns error message when password is too long" do
      user.password = "A" * 256
      user.valid?
      expect(user.errors[:password]).to include(I18n.t('activerecord.errors.models.user.attributes.password.too_long'))
    end
  end

end
