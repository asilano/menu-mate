require 'rails_helper'

RSpec.describe MenuPlan, type: :model do
  let(:user) { create(:user) }

  context "using leftovers" do
    let(:roast) { create(:tag, user:, name: "roast") }
    let(:pork_leftovers) { create(:leftover, user:, name: "Pork") }
    let!(:roast_pork) do
      create(:recipe,
        name: "Roast Pork",
        user:,
        tags: [roast],
        leftovers_source: build(:leftovers_source, leftover: pork_leftovers, num_days: 2))
    end
    let!(:pork_tacos) do
      create(:recipe,
        name: "Pork Tacos",
        user:,
        tags: [],
        leftovers_sink: build(:leftovers_sink, leftover: pork_leftovers))
    end
    let!(:pork_bao_buns) do
      create(:recipe,
        name: "Pork Bao Buns",
        user:,
        tags: [],
        leftovers_sink: build(:leftovers_sink, leftover: pork_leftovers))
    end
    let!(:spaghetti_bolognese) do
      create(:recipe,
        name: "Spaghetti Bolognese",
        user:,
        tags: [])
    end

    let(:monday) { build(:plan_day, user:, day_number: 1, tags: [roast]) }
    let(:tuesday) { build(:plan_day, user:, day_number: 2) }
    let(:wednesday) { build(:plan_day, user:, day_number: 3) }
    let(:thursday) { build(:plan_day, user:, day_number: 4) }
    let(:menu_plan) { create(:menu_plan, user:, plan_days: [monday, tuesday, wednesday, thursday]) }

    it "enforces leftover use-ups after leftover producers" do
      10.times do
        menu_plan.fill
        expect(monday.recipe).to eq roast_pork
        expect([tuesday, wednesday].map(&:recipe)).to match_array([pork_tacos, pork_bao_buns])
        expect(thursday.recipe).to eq spaghetti_bolognese
      end
    end

    context "when leftover use-up days are also tagged with compatible tags" do
      let(:quick) { create(:tag, user:, name: "quick") }
      let(:tuesday) { build(:plan_day, user:, day_number: 2, tags: [quick]) }
      let!(:pork_tacos) do
        create(:recipe,
          name: "Pork Tacos",
          user:,
          tags: [quick],
          leftovers_sink: build(:leftovers_sink, leftover: pork_leftovers))
      end

      it "enforces leftover use-ups with tags after leftover producers" do
        10.times do
          menu_plan.fill
          expect(monday.recipe).to eq roast_pork
          expect(tuesday.recipe).to eq pork_tacos
          expect(wednesday.recipe).to eq pork_bao_buns
          expect(thursday.recipe).to eq spaghetti_bolognese
        end
      end
    end

    context "when leftover use-up days are also tagged with incompatible tags" do
      let(:quick) { create(:tag, user:, name: "quick") }
      let(:tuesday) { build(:plan_day, user:, day_number: 2, tags: [quick]) }
      let!(:spaghetti_bolognese) do
        create(:recipe,
          name: "Spaghetti Bolognese",
          user:,
          tags: [quick])
      end

      it "enforces leftover use-ups with tags after leftover producers" do
        10.times do
          menu_plan.fill
          expect(monday.recipe).to eq roast_pork
          expect(tuesday.recipe).to eq spaghetti_bolognese
          expect([wednesday, thursday].map(&:recipe)).to match_array([pork_tacos, pork_bao_buns])
        end
      end
    end
  end
end
