require 'rails_helper'

RSpec.describe "/users", type: :request do
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_user) { create(:user)}
  let(:admin) { create(:user, role: 'admin') }
  let(:valid_attributes) { { name: "My name", email: "123test@test.com", password: "password"} }
  let(:invalid_attributes) { { no_name: "My name", no_email: "123test@test.com", no_password: "password"} }

  describe "GET /index" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get users_url
        expect(response).to redirect_to(login_url)
      end
    end

    context "when user is logged in" do
      it "redirects to home page if user is not an admin" do
        post login_url, params: { email: valid_user.email, password: valid_user.password }
        get users_url
        expect(response).to redirect_to(root_url)
      end

      it "renders a successful response if user is an admin" do
        post login_url, params: { email: admin.email, password: admin.password }
        get users_url
        expect(response).to be_successful
      end
    end

  end

  describe "GET /show" do
    context "when user is logged in" do
      it "renders a successful response " do
        post login_url, params: { email: valid_user.email, password: valid_user.password }
        get user_url(valid_user)
        expect(response).to be_successful
      end
    end

    it "redirects if user is not logged in " do
      get user_url(valid_user)
      expect(response).to redirect_to(login_url)
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get register_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      post login_url, params: { email: valid_user.email, password: valid_user.password }
      get edit_user_url(valid_user)
      expect(response).to be_successful
    end

    it "redirects to login page if user is not logged in" do
      get edit_user_url(valid_user)
      expect(response).to redirect_to(login_url)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested user" do
        post login_url, params: { email: valid_user.email, password: valid_user.password }
        valid_attributes[:name] = "Enugbe"
        valid_user = User.create(valid_attributes)
        patch user_url(valid_user), params: { user: valid_attributes, }
        valid_user.reload
        expect(valid_user.name).to eq("Enugbe")
      end

      it "redirects to the user" do
        valid_user = User.create(valid_attributes)
        post login_url, params: { email: valid_attributes[:email], password: valid_attributes[:password] }
        patch user_url(valid_user), params: { user: valid_attributes }
        valid_user.reload
        expect(response).to redirect_to(user_url(valid_user))
      end

      context "different user trying to edit another user" do
        it "redirects to home" do
          post login_url, params: { email: valid_user.email, password: valid_user.password }
          valid_user = User.create(valid_attributes)
          patch user_url(valid_user), params: { user: valid_attributes }
          valid_user.reload
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context "with invalid parameters" do
      it "fails model validations on invalid params" do
        user = User.create!(valid_attributes)
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to_not be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      post login_url, params: { email: valid_user.email, password: valid_user.password }
      expect {
        delete user_url(valid_user)
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      post login_url, params: { email: valid_user.email, password: valid_user.password }
      delete user_url(valid_user)
      expect(response).to redirect_to(users_url)
    end
  end

  describe "GET /create_admin" do
    it 'should fail if user is already an admin' do
      post login_url, params: { email: admin.email, password: admin.password }
      valid_user.admin!

      get admin_user_url(valid_user)

      expect {
        expect(response).to redirect_to(users_path)
        valid_user.reload
      }.to_not change { valid_user.admin? }
    end

    it 'should make a user an admin' do
      post login_url, params: { email: admin.email, password: admin.password }
      user = User.create!(valid_attributes)

      get admin_user_path(user)

      expect {
        expect(response).to redirect_to(users_path)
        user.reload
      }.to change {
        user.admin?
      }.to(true)
    end
  end

  describe "GET /create_agent" do
    it 'should fail if user is already an agent' do
      post login_url, params: { email: admin.email, password: admin.password }
      valid_user.agent!
      get agent_user_url(valid_user)

      expect {
        expect(response).to redirect_to(users_path)
        valid_user.reload
      }.to_not change { valid_user.agent? }
    end

    it 'should make a user an agent' do
      post login_url, params: { email: admin.email, password: admin.password }

      get agent_user_path(valid_user)
      expect {
        expect(response).to redirect_to(users_path)
        valid_user.reload
      }.to change {
        valid_user.agent?
      }.to(true)
    end
  end

  describe "GET /create_customer" do
    it 'should fail if user is already a customer' do
      post login_url, params: { email: admin.email, password: admin.password }

      get customer_user_url(valid_user)
      expect {
        expect(response).to redirect_to(users_path)
        valid_user.reload
      }.to_not change { valid_user.customer? }
    end

    it 'should make a user a customer' do
      post login_url, params: { email: admin.email, password: admin.password }

      valid_user.agent!
      get customer_user_path(valid_user)

      expect {
        expect(response).to redirect_to(users_path)
        valid_user.reload
      }.to change {
        valid_user.customer?
      }.to(true)
    end
  end
end
