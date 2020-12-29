# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AdminUsers", type: :request do
  let!(:user) { create(:user) }
  let!(:manager) { create(:manager) }
  let!(:moderator) { create(:moderator) }
  let!(:admin) { create(:admin) }
  let!(:user_tokens) { jwt_and_refresh_token(user, "user") }
  let!(:manager_tokens) { jwt_and_refresh_token(manager, "admin_user") }
  let!(:moderator_tokens) { jwt_and_refresh_token(moderator, "admin_user") }
  let!(:admin_tokens) { jwt_and_refresh_token(admin, "admin_user") }
  let!(:user_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{user_tokens[0]}" }}
  let!(:manager_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{manager_tokens[0]}" }}
  let!(:moderator_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{moderator_tokens[0]}" }}
  let!(:admin_headers) {{ "HTTP_AUTHORIZATION" => "Bearer #{admin_tokens[0]}" }}

  describe "GET admin_users#index" do
    before { get admin_users_path }

    it "is a success when authenticated and authorized" do
      get admin_users_path, headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized as user" do
      get admin_users_path, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as manager" do
      get admin_users_path, headers: manager_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as moderator" do
      get admin_users_path, headers: moderator_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns all users" do
      get admin_users_path, headers: admin_headers
      expect(response.body).to include(admin.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get admin_users_path, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "GET admin_users#show" do
    before { get admin_user_path(id: admin.id) }

    it "is a success when authenticated and authorized" do
      get admin_user_path(id: admin.id), headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized as user" do
      get admin_user_path(id: admin.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as manager" do
      get admin_user_path(id: admin.id), headers: manager_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as moderator" do
      get admin_user_path(id: admin.id), headers: moderator_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns requested admin" do
      get admin_user_path(id: admin.id), headers: admin_headers
      expect(response.body).to include(admin.to_json)
    end

    it "returns error message when not found" do
      get admin_user_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.admin_user.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get admin_user_path(id: admin.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "GET admin_users#me" do
    before { get me_admin_users_path }

    it "is a success when authenticated as manager" do
      get me_admin_users_path, headers: manager_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a success when authenticated as moderator" do
      get me_admin_users_path, headers: moderator_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a success when authenticated as admin" do
      get me_admin_users_path, headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when authenticated as user" do
      get me_admin_users_path, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns current logged admin" do
      get me_admin_users_path, headers: admin_headers
      expect(response.body).to include(admin.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      get me_admin_users_path, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "POST admin_users#create" do
    let!(:params) {{
      name: "Test Full Name",
      email: "other.test@adotae.com.br",
      password: "Test@0304"
    }}

    before { post admin_users_path, params: params }

    it "is a success when authenticated and valid params" do
      post admin_users_path, params: params, headers: admin_headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post admin_users_path, params: params.except(:email), headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized as user" do
      post admin_users_path, params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as manager" do
      post admin_users_path, params: params, headers: manager_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as moderator" do
      post admin_users_path, params: params, headers: moderator_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns created admin" do
      post admin_users_path, params: params, headers: admin_headers
      created_admin = AdminUser.find_by(email: params[:email])
      expect(response.body).to include(created_admin.to_json)
    end

    it "returns error message when name is not present" do
      post admin_users_path, params: params.except(:name), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.blank"))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      post admin_users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.too_short"))
    end

    it "returns error message when email is not present" do
      post admin_users_path, params: params.except(:email), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.blank"))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      post admin_users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.invalid"))
    end

    it "returns error message when password is not present" do
      post admin_users_path, params: params.except(:password), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.blank"))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      post admin_users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      post admin_users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      post admin_users_path, params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_long"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      post admin_users_path, params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "PUT admin_users#update" do
    let!(:admin_user) { create(:admin_user) }
    let!(:params) {{
      name: "New Test Name"
    }}

    before { put admin_user_path(id: admin_user.id), params: params }

    it "is a success when authenticated and valid params" do
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      admin_user.reload
      expect(admin_user[:name]).to be_eql(params[:name])
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params[:name] = "A"
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized as user" do
      put admin_user_path(id: admin_user.id), params: params, headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as manager" do
      put admin_user_path(id: admin_user.id), params: params, headers: manager_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as moderator" do
      put admin_user_path(id: admin_user.id), params: params, headers: moderator_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns updated admin" do
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      admin_user.reload
      body = JSON.parse(response.body)
      expect(body["data"]["id"]).to be_eql(admin_user.id)
      expect(body["data"]["name"]).to be_eql(admin_user.name)
      expect(body["data"]["email"]).to be_eql(admin_user.email)
    end

    it "returns error message when not found" do
      put admin_user_path(id: 999), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.admin_user.not_found"))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.name.too_short"))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.email.invalid"))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.invalid"))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_short"))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      put admin_user_path(id: admin_user.id), params: params, headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t("activerecord.errors.models.admin_user.attributes.password.too_long"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      put admin_user_path(id: user.id), params: params, headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end

  describe "DELETE admin_users#destroy" do
    let!(:admin_user) { create(:admin_user) }

    before { delete admin_user_path(id: admin_user.id) }

    it "is a success when authenticated" do
      delete admin_user_path(id: admin_user.id), headers: admin_headers
      expect { AdminUser.find(admin_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "is a failure when unauthorized as user" do
      delete admin_user_path(id: user.id), headers: user_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as manager" do
      delete admin_user_path(id: user.id), headers: manager_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "is a failure when unauthorized as moderator" do
      delete admin_user_path(id: user.id), headers: moderator_headers
      expect(response).to have_http_status(:forbidden)
    end

    it "returns deleted admin" do
      delete admin_user_path(id: admin_user.id), headers: admin_headers
      expect(response.body).to include(admin_user.to_json)
    end

    it "returns error message when error on destroying" do
      allow(AdminUser).to receive(:find).with(admin_user.id.to_s).and_return(admin_user)
      allow(admin_user).to receive(:destroy).and_return(false)

      delete admin_user_path(id: admin_user.id), headers: admin_headers
      
      body = JSON.parse(response.body)
      expect(AdminUser).to have_received(:find)
      expect(admin_user).to have_received(:destroy)
      expect(body["error"]).to include(I18n.t("adotae.errors.admin_user.on_destroy"))
    end

    it "returns error message when not found" do
      delete admin_user_path(id: 999), headers: admin_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.admin_user.not_found"))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("api_guard.access_token.missing"))
    end

    it "returns error message when unauthorized" do
      delete admin_user_path(id: admin_user.id), headers: user_headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t("adotae.errors.authorization.unauthorized"))
    end
  end
end
