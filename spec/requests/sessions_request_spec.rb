require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/register"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      delete "/logout"
      expect(response).to redirect_to(login_url)
    end
  end

end
