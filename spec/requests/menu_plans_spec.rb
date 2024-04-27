require 'rails_helper'

RSpec.describe "MenuPlans", type: :request do
  context "when logged in" do
    let(:user) { create(:user) }

    before { login_as user }

    describe "GET /menu_plans/new" do
      it "redirects to the edit path" do
        get new_menu_plan_path
        expect(response).to redirect_to(edit_menu_plan_path)
      end

      context "without an existing plan" do
        before { MenuPlan.destroy_all }

        it "creates a menu plan for the current user" do
          expect { get new_menu_plan_path }.to change { MenuPlan.count }.from(0).to(1)
          expect(user.menu_plan).not_to be_nil
        end
      end

      context "with an existing plan" do
        let!(:menu_plan) { create(:menu_plan, user:) }

        it "replaces the current user's menu plan" do
          expect { get new_menu_plan_path }.to not_change { MenuPlan.count }
            .and change { user.reload.menu_plan.id }
        end
      end
    end

    describe "GET /menu_plans/edit" do
      let!(:menu_plan) { create(:menu_plan, user:) }

      it "has a template for exactly 7 days" do
        get edit_menu_plan_path
        1.upto(7) do |n|
          expect(response.body).to include "Day #{n}"
        end

        expect(response.body).not_to include "Day 8"
      end
    end

    describe "POST /menu_plan/update_number_of_days" do
      let!(:menu_plan) { create(:menu_plan, user:) }
      it "has a template for the specified days" do
        post update_number_of_days_menu_plan_path, params: {
          menu_plan: {
            num_days: 5
          }
        }, as: :turbo_stream

        1.upto(5) do |n|
          expect(response.body).to include "Day #{n}"
        end

        expect(response.body).not_to include "Day 6"

        post update_number_of_days_menu_plan_path, params: {
          menu_plan: {
            num_days: 8
          }
        }, as: :turbo_stream

        1.upto(8) do |n|
          expect(response.body).to include "Day #{n}"
        end

        expect(response.body).not_to include "Day 9"
      end
    end

    describe "POST /menu_plan/fill_recipes" do
      let!(:menu_plan) { create(:menu_plan, user:) }
      let!(:recipes) { [
        create(:recipe, user:, name: "Arancini"),
        create(:recipe, user:, name: "Borst"),
        create(:recipe, user:, name: "Crème Brulée"),
        create(:recipe, user:, name: "Duck pancakes")
      ] }
      let(:recipes_stub) { double() }

      before do
        expect(Current).to receive(:user).at_least(1).and_return(user)
        expect(user).to receive(:recipes).and_return(recipes_stub)
        expect(recipes_stub).to receive(:shuffle).and_return ([1, 3, 0, 2].map { |n| recipes[n] })
      end

      it "has a template for the specified days" do
        post fill_recipes_menu_plan_path, as: :turbo_stream

        expect(response.body).to include "Borst"
        expect(response.body).to include "Duck pancakes"
        expect(response.body).to include "Arancini"
        expect(response.body).to include "Crème Brulée"
        expect(response.body).to include "No suitable recipe"
      end
    end
  end

  context "when not logged in" do
    describe "GET /menu_plans/new" do
      it "redirects to the root page" do
        get new_menu_plan_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
