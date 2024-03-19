require 'rails_helper'

RSpec.describe "MenuPlans", type: :request do
  context "when logged in" do
    let(:user) { create(:user) }

    before { login_as user }

    describe "GET /menu_plans/new" do
      it "returns success" do
        get new_menu_plan_path
        expect(response).to have_http_status(:success)
      end

      it "has a template for exactly 7 days" do
        get new_menu_plan_path
        1.upto(7) do |n|
          expect(response.body).to include "Day #{n}"
        end

        expect(response.body).not_to include "Day 8"
      end
    end

    describe "POST /menu_plans/update_plan" do
      describe "when blank_plan is true" do
        it "has a template for the specified days" do
          post update_plan_menu_plans_path, params: {
            num_days: 5,
            blank_plan: true
          }, as: :turbo_stream

          1.upto(5) do |n|
            expect(response.body).to include "Day #{n}"
          end

          expect(response.body).not_to include "Day 6"
        end
      end


      describe "when blank_plan is false" do
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
          expect(recipes_stub).to receive(:shuffle).and_return ([1, 3, 0].map { |n| recipes[n] })
        end

        it "has a template for the specified days" do
          post update_plan_menu_plans_path, params: {
            num_days: 3,
            blank_plan: false
          }, as: :turbo_stream

          1.upto(3) do |n|
            expect(response.body).to include "Day #{3}"
          end

          expect(response.body).to include "Borst"
          expect(response.body).to include "Duck pancakes"
          expect(response.body).to include "Arancini"
        end
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
