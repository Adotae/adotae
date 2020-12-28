require 'rails_helper'

RSpec.describe Role, type: :model do

  context "validates role" do
    let!(:role) { create(:role) }
    let!(:role_with_invalid_role) { build(:role_with_invalid_role) }
    let!(:role_with_invalid_admin) { build(:role_with_invalid_admin) }

    it "is valid" do
      expect(role).to be_valid
    end

    it "is not valid" do
      expect(role_with_invalid_role).to_not be_valid
      expect(role_with_invalid_admin).to_not be_valid
    end
    
    it "returns error message when user already has the role defined" do
      new_role = Role.new admin_user_id: role.admin_user_id, role: role.role
      new_role.valid?
      expect(new_role.errors[:role]).to include(
        I18n.t('activerecord.errors.models.role.attributes.role.taken'))
    end
  end
  
  context "validates role name" do
    let!(:role) { build(:role_with_invalid_role) }

    it "returns error message when role is not defined" do
      role.valid?
      expect(role.errors[:role]).to include(
        I18n.t('activerecord.errors.models.role.attributes.role.invalid'))
    end

    it "returns error message when role is nil" do
      role.role = nil
      role.valid?
      expect(role.errors[:role]).to include(
        I18n.t('activerecord.errors.models.role.attributes.role.blank'))
    end

    it "returns error message when role is empty" do
      role.role = ""
      role.valid?
      expect(role.errors[:role]).to include(
        I18n.t('activerecord.errors.models.role.attributes.role.blank'))
    end
  end

  context "validates role admin id" do
    let!(:role) { build(:role_with_invalid_admin) }
    
    it "returns error message when admin id is invalid" do
      role.valid?
      expect(role.errors[:admin_user]).to include(
        I18n.t('activerecord.errors.models.role.attributes.admin_user.required'))
    end

    it "returns error message when admin id is nil" do
      role.admin_user_id = nil
      role.valid?
      expect(role.errors[:admin_user]).to include(
        I18n.t('activerecord.errors.models.role.attributes.admin_user.required'))
    end

    it "returns error message when admin id is empty" do
      role.admin_user_id = ""
      role.valid?
      expect(role.errors[:admin_user]).to include(
        I18n.t('activerecord.errors.models.role.attributes.admin_user.required'))
    end
  end

end
