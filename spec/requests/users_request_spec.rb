# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let!(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  let!(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let!(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

  describe "GET users#index" do
    before { get users_path }

    it "is a success when authenticated and authorized" do
      get users_path, headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      get users_path, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns all users" do
      get users_path, headers: admin_headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get users_path, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "GET users#show" do
    before { get user_path(id: user.id) }

    it "is a success when authenticated and authorized" do
      get user_path(id: user.id), headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      get user_path(id: user.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns requested user" do
      get user_path(id: user.id), headers: admin_headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when not found" do
      get user_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get user_path(id: user.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "GET users#me" do
    before { get me_users_path }

    it "is a success when authenticated as user" do
      get me_users_path, headers: user_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when authenticated as admin" do
      get me_users_path, headers: admin_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns current logged user" do
      get me_users_path, headers: user_headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get me_users_path, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "POST users#create" do
    let!(:params) {{
      name: "Test Full Name",
      email: "other.test@adotae.com.br",
      phone: "(11) 93333-2222",
      password: "Test@0304"
    }}

    before { post users_path, params: params }

    it "is a success when authenticated and valid params" do
      post users_path, params: params, headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post users_path, params: params.except(:email), headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      post users_path, params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns created user" do
      post users_path, params: params, headers: admin_headers
      created_user = User.find_by(email: params[:email])
      expect(response.body).to include(created_user.to_json)
    end

    it "returns error message when name is not present" do
      post users_path, params: params.except(:name), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.name.blank"))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.name.too_short"))
    end

    it "returns error message when email is not present" do
      post users_path, params: params.except(:email), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.email.blank"))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
    end

    it "returns error message when phone has invalid format" do
      params[:phone] = "11 90000-1111"
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.phone.invalid"))
    end

    it "returns error message when password is not present" do
      post users_path, params: params.except(:password), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.blank"))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.invalid"))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      post users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_long"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      post users_path, params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "PUT users#update" do
    let!(:user) { create(:user) }
    let!(:params) {{
      name: "New Test Name",
      phone: "(11) 93333-2222"
    }}

    before { put user_path(id: user.id), params: params }

    it "is a success when authenticated and valid params" do
      put user_path(id: user.id), params: params, headers: admin_headers
      user.reload
      expect(user[:name]).to be_eql(params[:name])
      expect(user[:phone]).to be_eql(params[:phone])
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params[:name] = "A"
      put user_path(id: user.id), params: params, headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      put user_path(id: user.id), params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns updated user" do
      put user_path(id: user.id), params: params, headers: admin_headers
      user.reload
      body = JSON.parse(response.body)
      expect(body["data"]["id"]).to be_eql(user.id)
      expect(body["data"]["name"]).to be_eql(user.name)
      expect(body["data"]["email"]).to be_eql(user.email)
      expect(body["data"]["phone"]).to be_eql(user.phone)
    end

    it "returns error message when not found" do
      put user_path(id: 999), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.name.too_short"))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.email.invalid"))
    end

    it "returns error message when phone has invalid format" do
      params[:phone] = "11 90000-1111"
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.phone.invalid"))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.invalid"))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      put user_path(id: user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.user.attributes.password.too_long"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      put user_path(id: user.id), params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "DELETE users#destroy" do
    let!(:user) { create(:user) }

    before { delete user_path(id: user.id) }

    it "is a success when authenticated" do
      delete user_path(id: user.id), headers: admin_headers
      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      delete user_path(id: user.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns deleted user" do
      delete user_path(id: user.id), headers: admin_headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when error on destroying" do
      allow(User).to receive(:find).with(user.id.to_s).and_return(user)
      allow(user).to receive(:destroy).and_return(false)

      delete user_path(id: user.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      expect(User).to have_received(:find)
      expect(user).to have_received(:destroy)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.on_destroy"))
    end

    it "returns error message when not found" do
      delete user_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.user.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      delete user_path(id: user.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end
end
