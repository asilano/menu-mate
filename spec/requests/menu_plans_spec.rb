require 'rails_helper'

RSpec.describe "MenuPlans", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/menu_plans/new"
      expect(response).to have_http_status(:success)
    end
  end
end
