require 'rails_helper'

RSpec.describe "Users", type: :request do

  let!(:user) { create(:user) }
  let!(:tokens) { jwt_and_refresh_token(user, 'user') }
  let!(:headers) {{ 'HTTP_AUTHORIZATION' => "Bearer #{ tokens[0] }" }}

  describe "GET users#index" do
    before(:example) { get users_path }
    
    it "is a success when authenticated" do
      get users_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns all users" do
      get users_path, headers: headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

  describe "GET users#show" do
    before(:example) { get user_path(id: user.id) }
    
    it "is a success when authenticated" do
      get user_path(id: user.id), headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns requested user" do
      get user_path(id: user.id), headers: headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when not found" do
      get user_path(id: 999), headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('adotae.errors.user.not_found'))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

  describe "GET users#me" do
    before(:example) { get me_users_path }
    
    it "is a success when authenticated" do
      get me_users_path, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns current logged user" do
      get me_users_path, headers: headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

  describe "POST users#create" do
    let!(:params) {{
      name: 'Test Full Name',
      email: 'other.test@adotae.com.br',
      phone: '(11) 93333-2222',
      password: 'Test@0304'
    }}

    before(:example) { post users_path, params: params }
    
    it "is a success when authenticated and valid params" do
      post users_path, params: params, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      post users_path, params: params.except(:email), headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns created user" do
      post users_path, params: params, headers: headers
      created_user = User.find_by(email: params[:email])
      expect(response.body).to include(created_user.to_json)
    end

    it "returns error message when name is not present" do
      post users_path, params: params.except(:name), headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.name.blank'))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.name.too_short'))
    end

    it "returns error message when email is not present" do
      post users_path, params: params.except(:email), headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.email.blank'))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.email.invalid'))
    end

    it "returns error message when phone has invalid format" do
      params[:phone] = "11 90000-1111"
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.phone.invalid'))
    end

    it "returns error message when password is not present" do
      post users_path, params: params.except(:password), headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.blank'))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.invalid'))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.too_short'))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      post users_path, params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.too_long'))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

  describe "PUT users#update" do
    let!(:user) { create(:user) }
    let!(:params) {{
      name: 'New Test Name',
      phone: '(11) 93333-2222'
    }}

    before(:example) { put user_path(id: user.id), params: params }
    
    it "is a success when authenticated and valid params" do
      put user_path(id: user.id), params: params, headers: headers
      user.reload
      expect(user[:name]).to be_eql(params[:name])
      expect(user[:phone]).to be_eql(params[:phone])
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when invalid params" do
      params[:name] = "A"
      put user_path(id: user.id), params: params, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns updated user" do
      put user_path(id: user.id), params: params, headers: headers
      user.reload
      body = JSON.parse(response.body)
      expect(body["data"]["id"]).to be_eql(user.id)
      expect(body["data"]["name"]).to be_eql(user.name)
      expect(body["data"]["email"]).to be_eql(user.email)
      expect(body["data"]["phone"]).to be_eql(user.phone)
    end

    it "returns error message when not found" do
      put user_path(id: 999), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('adotae.errors.user.not_found'))
    end

    it "returns error message when name is not full name" do
      params[:name] = "A"
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.name.too_short'))
    end

    it "returns error message when email has invalid format" do
      params[:email] = "adotae @adotae.com.br"
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.email.invalid'))
    end

    it "returns error message when phone has invalid format" do
      params[:phone] = "11 90000-1111"
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.phone.invalid'))
    end

    it "returns error message when password has invalid format" do
      params[:password] = "abc02020202"
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.invalid'))
    end

    it "returns error message when password is too short" do
      params[:password] = "A"
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.too_short'))
    end

    it "returns error message when password is too long" do
      params[:password] = "A" * 101
      put user_path(id: user.id), params: params, headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(
        I18n.t('activerecord.errors.models.user.attributes.password.too_long'))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

  describe "DELETE users#destroy" do
    let!(:user) { create(:user) }

    before(:example) { delete user_path(id: user.id) }

    it "is a success when authenticated" do
      delete user_path(id: user.id), headers: headers
      expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(response).to have_http_status(:ok)
    end

    it "is a failure when unauthenticated" do
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns deleted user" do
      delete user_path(id: user.id), headers: headers
      expect(response.body).to include(user.to_json)
    end

    it "returns error message when not found" do
      delete user_path(id: 999), headers: headers
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('adotae.errors.user.not_found'))
    end

    it "returns error message when unauthenticated" do
      body = JSON.parse(response.body)
      expect(body["error"]).to include(I18n.t('api_guard.access_token.missing'))
    end
  end

end