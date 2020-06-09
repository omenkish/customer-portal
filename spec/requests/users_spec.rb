require 'rails_helper'

RSpec.describe "/users", type: :request do
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let!(:valid_user) { create(:user)}

  let(:valid_attributes) { { name: "My name", email: "123test@test.com", password: "password"} }
  let(:invalid_attributes) { { no_name: "My name", no_email: "123test@test.com", no_password: "password"} }

  describe "GET /index" do
    it "renders a successful response" do
      valid_user
      get users_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_url(valid_user)
      expect(response).to be_successful
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
      valid_user
      get edit_user_url(valid_user)
      expect(response).to be_successful
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
        valid_user = User.create(valid_attributes)
        patch user_url(valid_user), params: { user: valid_attributes }
        valid_user.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the user" do
        valid_user = User.create(valid_attributes)
        patch user_url(valid_user), params: { user: valid_attributes }
        valid_user.reload
        expect(response).to redirect_to(user_url(valid_user))
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
      expect {
        delete user_url(valid_user)
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      delete user_url(valid_user)
      expect(response).to redirect_to(users_url)
    end
  end
end
