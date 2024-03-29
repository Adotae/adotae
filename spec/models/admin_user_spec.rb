require "rails_helper"

RSpec.describe AdminUser, type: :model do

  context "validates admin name" do
    let!(:admin) { create(:admin_user) }

    it "is valid" do
      admin.name = "Test Test Test"
      expect(admin).to be_valid
    end

    it "is not valid" do
      admin.name = nil
      expect(admin).to_not be_valid
    end

    it "returns error message when name is nil" do
      admin.name = nil
      admin.valid?
      expect(admin.errors[:name]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.blank"))
    end

    it "returns error message when name is empty" do
      admin.name = ""
      admin.valid?
      expect(admin.errors[:name]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.blank"))
    end

    it "returns error message when name is too short" do
      admin.name = "Ana"
      admin.valid?
      expect(admin.errors[:name]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.too_short"))
    end

    it "returns error message when name is too long" do
      admin.name = "A" * 256
      admin.valid?
      expect(admin.errors[:name]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.too_long"))
    end
  end

  context "validates admin email" do
    let!(:admin) { create(:admin_user) }

    it "is valid" do
      admin.email = "test@adotae.com.br"
      expect(admin).to be_valid
    end

    it "is not valid when nil" do
      admin.email = nil
      expect(admin).to_not be_valid
    end

    it "is not valid when invalid format" do
      admin.email = " test @adotaecom"
      expect(admin).to_not be_valid
    end

    it "returns error message when email is nil" do
      admin.email = nil
      admin.valid?
      expect(admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.blank"))
    end

    it "returns error message when email is empty" do
      admin.email = ""
      admin.valid?
      expect(admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.blank"))
    end

    it "returns error message when email is already in use" do
      admin.save!
      another_admin = AdminUser.new email: admin.email
      another_admin.valid?
      expect(another_admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.taken"))
    end

    it "returns error message when email is already in use: considering case" do
      admin.save!
      another_admin = AdminUser.new email: admin.email.upcase
      another_admin.valid?
      expect(another_admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.taken"))
    end

    it "returns error message when email format is invalid: with spaces" do
      admin.email = "a test @adotae.com.br"
      admin.valid?
      expect(admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.invalid"))
    end

    it "returns error message when email format is invalid: missing @" do
      admin.email = "atest#adotae.com.br"
      admin.valid?
      expect(admin.errors[:email]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.invalid"))
    end
  end

  context "validates admin password" do
    let!(:admin) { create(:admin_user) }

    it "is valid" do
      admin.password = "Aaaaaa@0"
      expect(admin).to be_valid
    end

    it "is not valid when nil" do
      another_admin = AdminUser.new password: nil
      expect(another_admin).to_not be_valid
    end

    it "is not valid when invalid format" do
      admin.password = "11 9000-1111"
      expect(admin).to_not be_valid
    end

    it "returns error message when password is nil" do
      another_admin = AdminUser.new password: nil
      another_admin.valid?
      expect(another_admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.blank"))
    end

    it "returns error message when password is empty" do
      another_admin = AdminUser.new password: ""
      another_admin.valid?
      expect(another_admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.blank"))
    end

    it "returns error message when password is too short" do
      admin.password = "test"
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      admin.password = "A" * 256
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_long"))
    end

    it "returns error message when password is different from confirmation" do
      another_admin = User.new password: "Test@0202", password_confirmation: "Test@0203"
      another_admin.valid?
      expect(another_admin.errors[:password_confirmation]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password_confirmation.confirmation"))
    end

    it "returns error message when password format is invalid: missing uppercase letter" do
      admin.password = "test@123456"
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end

    it "returns error message when password format is invalid: missing lowercase letter" do
      admin.password = "TEST@123456"
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end

    it "returns error message when password format is invalid: missing special character" do
      admin.password = "Test123456"
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end

    it "returns error message when password format is invalid: missing number" do
      admin.password = "Test@Test"
      admin.valid?
      expect(admin.errors[:password]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end
  end

  context "validates admin cpf" do
    let!(:admin) { create(:admin_user) }

    it "is valid" do
      expect(admin).to be_valid
    end

    it "is not valid when nil" do
      admin.cpf = nil
      expect(admin).to_not be_valid
    end

    it "is not valid when invalid format" do
      admin.cpf = "000.000.000-00"
      expect(admin).to_not be_valid
    end

    it "returns error message when cpf is nil" do
      admin.cpf = nil
      admin.valid?
      expect(admin.errors[:cpf]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.cpf.blank"))
    end

    it "returns error message when cpf is empty" do
      admin.cpf = ""
      admin.valid?
      expect(admin.errors[:cpf]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.cpf.blank"))
    end

    it "returns error message when cpf is already in use" do
      admin.save!
      another_admin = AdminUser.new cpf: admin.cpf
      another_admin.valid?
      expect(another_admin.errors[:cpf]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.cpf.taken"))
    end

    it "returns error message when cpf format is invalid" do
      admin.cpf = "000.000.000-00"
      admin.valid?
      expect(admin.errors[:cpf]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.cpf.invalid"))
    end

    it "returns error message when cpf is invalid" do
      admin.cpf = "00000000000"
      admin.valid?
      expect(admin.errors[:cpf]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.cpf.invalid"))
    end
  end

  context "validates admin roles" do
    let!(:admin) { create(:admin_user) }

    it "add manager role for user" do
      admin.add_role("manager")
      role = Role.where(admin_user_id: admin.id, role: "manager").last
      expect(role).not_to be_nil
      expect(role.active).to be_truthy
      expect(admin.manager?).to be_truthy
    end

    it "add moderator role for user" do
      admin.add_role("moderator")
      role = Role.where(admin_user_id: admin.id, role: "moderator").last
      expect(role).not_to be_nil
      expect(role.active).to be_truthy
      expect(admin.moderator?).to be_truthy
    end

    it "add admin role for user" do
      admin.add_role("admin")
      role = Role.where(admin_user_id: admin.id, role: "admin").last
      expect(role).not_to be_nil
      expect(role.active).to be_truthy
      expect(admin.admin?).to be_truthy
    end

    it "remove role for user" do
      admin.add_role("admin")
      admin.remove_role("admin")
      role = Role.where(admin_user_id: admin.id, role: "admin").last
      expect(role).not_to be_nil
      expect(role.active).to be_falsey
    end

    it "active role if role is already defined for user and is inactive" do
      role = admin.add_role("admin")
      admin.remove_role("admin")
      admin.add_role("admin")
      new_role = Role.where(admin_user_id: admin.id, role: "admin").last
      expect(role.id).to be_eql(new_role.id)
      expect(role.reload.active).to be_truthy
    end

    it "inactive role if role is already defined for user and is active" do
      role = admin.add_role("admin")
      admin.remove_role("admin")
      new_role = Role.where(admin_user_id: admin.id, role: "admin").last
      expect(role.id).to be_eql(new_role.id)
      expect(role.reload.active).to be_falsey
    end
  end
end
