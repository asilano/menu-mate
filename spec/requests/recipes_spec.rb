require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  context "when logged in" do
    let(:user) { create(:user) }

    before { login_as user }

    describe "GET /recipes" do
      it "returns success" do
        get recipes_path
        expect(response).to have_http_status(:success)
      end

      context "with pre-saved recipes" do
        let!(:recipes) { [
          create(:recipe, user:, name: "Arancini"),
          create(:recipe, user:, name: "Borst"),
          create(:recipe, user:, name: "Crème Brulée")
        ] }

        it "lists all the recipes" do
          get recipes_path
          expect(response.body).to include "Recipes"
          expect(response.body).to include("Arancini")
          expect(response.body).to include("Borst")
          expect(response.body).to include("Crème Brulée")
        end
      end
    end
  end

  context "when not logged in" do
    describe "GET /recipes" do
      it "redirects to the root page" do
        get recipes_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
