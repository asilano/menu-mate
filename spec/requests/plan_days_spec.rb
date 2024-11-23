require 'rails_helper'

RSpec.describe "PlanDays", type: :request do
  context "when logged in" do
    let(:user) { create(:user) }
    let(:menu_plan) { create(:menu_plan, user:) }
    let(:plan_day) { menu_plan.plan_days.first }

    before { login_as user }

    describe "GET /plan_day/:id/edit" do
      it "returns a turbo_stream to edit the day" do
        get edit_plan_day_path(plan_day), headers: { "Turbo-Frame": "modal" }
        expect(response).to be_successful
        expect(response.body).to include %q(<turbo-frame id="modal")
        expect(response.body).to include "Edit Day 1"
      end
    end

    describe "PUT /plan_day/:id" do
      let!(:quick_tag) { create(:tag, user:, name: "quick") }
      let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
      let!(:vegan_tag) { create(:tag, user:, name: "vegan") }

      describe "with valid params" do
        let(:params) do
          {
            plan_day: {
              tag_ids: [vegetarian_tag.id, quick_tag.id]
            }
          }
        end

        it "returns success" do
          put plan_day_path(plan_day), params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "edits the plan_day" do
          put plan_day_path(plan_day), params:, as: :turbo_stream
          expect(plan_day.tags.reload).to contain_exactly(vegetarian_tag, quick_tag)
        end
      end

      xdescribe "with invalid params" do
        let(:params) do
          {
            plan_day: {
              tag_ids: [-1]
            }
          }
        end

        it "returns success" do
          put plan_day_path(plan_day), params: params, as: :turbo_stream
          expect(response).to have_http_status :success
        end

        it "does not modify the plan_day" do
          put plan_day_path(plan_day), params:, as: :turbo_stream
          expect(plan_day.tags).to be_empty
        end
      end
    end
  end

  context "when not logged in" do
    describe "GET /plan_day/:id/new" do
      let(:menu_plan) { create(:menu_plan) }
      let(:plan_day) { create(:plan_day, menu_plan:) }

      it "redirects to the root page" do
        get edit_plan_day_path(plan_day)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
