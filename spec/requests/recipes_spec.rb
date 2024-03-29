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
          expect(response.body).to include "Arancini"
          expect(response.body).to include "Borst"
          expect(response.body).to include "Crème Brulée"
        end
      end
    end

    describe "POST /recipes" do
      describe "with valid params" do
        let!(:quick_tag) { create(:tag, user:, name: "quick") }
        let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
        let!(:vegan_tag) { create(:tag, user:, name: "vegan") }
        let(:params) do
          {
            recipe: {
              name: "Tiramisu",
              tag_ids: [quick_tag.id, vegan_tag.id]
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
          expect(Recipe.last.tags).to match [quick_tag, vegan_tag]
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

    describe "PUT /recipes" do
      let!(:quick_tag) { create(:tag, user:, name: "quick") }
      let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
      let!(:vegan_tag) { create(:tag, user:, name: "vegan") }
      let!(:recipe) { create(:recipe, name: "Bolognese", user:) }
      describe "with valid params" do
        let(:params) do
          {
            recipe: {
              name: "Tiramisu",
              tag_ids: [vegetarian_tag.id, quick_tag.id]
            }
          }
        end

        it "returns success" do
          put recipe_path(recipe), params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "edits the recipe" do
          put recipe_path(recipe), params:, as: :turbo_stream
          expect(recipe.reload.name).to eq "Tiramisu"
          expect(recipe.tags.map(&:id)).to contain_exactly(vegetarian_tag.id, quick_tag.id)
        end
      end

      describe "with invalid params" do
        let(:params) do
          {
            recipe: {
              name: "",
              tag_ids: [quick_tag.id]
            }
          }
        end

        it "returns success" do
          put recipe_path(recipe), params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "does not modify the recipe" do
          put recipe_path(recipe), params:, as: :turbo_stream
          expect(recipe.reload.name).to eq "Bolognese"
          expect(recipe.tags).to be_empty
        end
      end
    end

    describe "DELETE /recipe/:id" do
      context "for a recipe that exists" do
        let!(:recipe) { create(:recipe, user:) }

        it "returns success" do
          delete recipe_path(recipe), as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "removes the recipe" do
          expect { delete recipe_path(recipe), as: :turbo_stream }.to change { Recipe.count }.by(-1)
          expect(Recipe.find_by(id: recipe.id)).to be_nil
        end
      end

      context "for a recipe that doesn't exist" do
        it "redirects to /recipes" do
          Recipe.destroy_all
          delete recipe_path(1), as: :turbo_stream
          expect(response).to redirect_to(recipes_path)
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
