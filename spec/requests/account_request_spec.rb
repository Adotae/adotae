require 'rails_helper'

RSpec.describe "Accounts", type: :request do

  describe "POST account#create" do
    let!(:params) {{
      name: "Test Full Name",
      email: "other.test@adotae.com.br",
      phone: "(11) 93333-2222",
      password: "Test@0304",
      cpf: CPF.generate
    }}

    it "is a success when valid params" do
      post account_create_path, params: params
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post account_create_path, params: params.except(:email)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns successful message" do
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["message"]).to include(
        I18n.t("api_guard.registration.signed_up"))
    end

    it "returns error message when name is not present" do
      post account_create_path, params: params.except(:name)
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.name.blank"))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.name.too_short"))
    end

    it "returns error message when email is not present" do
      post account_create_path, params: params.except(:email)
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.email.blank"))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
    end

    it "returns error message when phone has invalid format" do
      params[:phone] = "11 90000-1111"
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.phone.invalid"))
    end

    it "returns error message when password is not present" do
      post account_create_path, params: params.except(:password)
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.blank"))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.invalid"))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      post account_create_path, params: params
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_long"))
    end
  end
end
