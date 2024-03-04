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

    describe "POST /recipes" do
      describe "with valid params" do
        let(:params) do
          {
            recipe: {
              name: "Tiramisu"
            }
          }
        end

        it "returns success" do
          post recipes_path, params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "creates a new recipe" do
          expect { post recipes_path, params:, as: :turbo_stream }.to change { Recipe.count }.by 1
          expect(Recipe.last.name).to eq "Tiramisu"
        end
      end

      describe "with invalid params" do
        let(:params) do
          {
            recipe: {
              name: ""
            }
          }
        end

        it "returns success" do
          post recipes_path, params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "does not create a new recipe" do
          expect { post recipes_path, params:, as: :turbo_stream }.not_to change { Recipe.count }
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
