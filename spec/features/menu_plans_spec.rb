# frozen_string_literal: true

require "rails_helper"

RSpec.feature "menu_plans", js: true do
  let(:user) { create(:user) }
  let(:zabaglione) { create(:recipe, user:, name: "Zabaglione") }
  let(:quince_jam) { create(:recipe, user:, name: "Quince jam") }
  let(:lemon_cake) { create(:recipe, user:, name: "Lemon cake") }
  let(:tiramisu)   { create(:recipe, user:, name: "Tiramisu") }
  let(:syllabub)   { create(:recipe, user:, name: "Syllabub") }
  let(:recipes_stub) { double }

  before do
    allow(Current).to receive(:user).and_return(user)
    allow(user).to receive(:recipes).and_return(recipes_stub)
    allow(recipes_stub).to receive(:shuffle).and_return ([
      syllabub,
      lemon_cake,
      zabaglione,
      quince_jam,
      tiramisu
    ])
  end

  describe "setting up a new plan" do
    before { visit "/menu_plans/new" }

    it "renders a form and an initial 7 days, then handles the form" do
      expect(page).to have_title("Menu Mate - Menu Plan")
      expect(page).to have_css("form #num_days")
      within("#menu-plan") do
        expect(page).to have_css(".plan-day", count: 7)
      end

      fill_in("Number of days", with: 5)
      click_on("Start plan")

      expect(page).to have_css("form #num_days")
      within("#menu-plan") do
        expect(page).to have_css(".plan-day", count: 5)
      end
    end

    it "fills a short plan with randomised recipes" do
      fill_in("Number of days", with: 3)
      click_on("Start plan")

      expect(page).to have_css(".plan-day", count: 3)
      click_on("Fill plan")

      expect(page).to have_css("#menu-plan", text: "Day 1\nSyllabub\nDay 2\nLemon cake\nDay 3\nZabaglione")
    end

    it "fills a long plan with randomised recipes, then blanks" do
      expect(page).to have_css(".plan-day", count: 7)
      click_on("Fill plan")

      expect(page).to have_css(".plan-day", text: "Day 1\nSyllabub")
      expect(page).to have_css(".plan-day", text: "Day 2\nLemon cake")
      expect(page).to have_css(".plan-day", text: "Day 3\nZabaglione")
      expect(page).to have_css(".plan-day", text: "Day 4\nQuince jam")
      expect(page).to have_css(".plan-day", text: "Day 5\nTiramisu")
      expect(page).to have_css(".plan-day", text: "Day 6\nNo suitable recipe")
      expect(page).to have_css(".plan-day", text: "Day 7\nNo suitable recipe")
    end
  end
end
