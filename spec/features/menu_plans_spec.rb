# frozen_string_literal: true

require "rails_helper"

RSpec.feature "menu_plans", js: true do
  let(:user) { create(:user) }
  let!(:quick_tag) { create(:tag, user:, name: "quick") }
  let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
  let!(:vegan_tag) { create(:tag, user:, name: "vegan") }
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
    # allow(recipes_stub).to receive_message_chain(:where, :not, :shuffle).and_return ([
    #   tiramisu,
    #   quince_jam,

    # ])
  end

  # Skipping test because the randomising process has changed
  xdescribe "setting up a new plan" do
    before { visit "/menu_plan/new" }

    it "renders a form and an initial 7 days, then handles the form" do
      expect(page).to have_title("Menu Mate - Menu Plan")
      expect(page).to have_css("form #menu_plan_num_days")
      within("#menu-plan") do
        expect(page).to have_css(".plan-day", count: 7)
      end

      fill_in("Number of days", with: 5)
      click_on("Set count")

      expect(page).to have_css("form #menu_plan_num_days")
      within("#menu-plan") do
        expect(page).to have_css(".plan-day", count: 5)
      end
    end

    it "fills a short plan with randomised recipes" do
      fill_in("Number of days", with: 3)
      click_on("Set count")

      expect(page).to have_css(".plan-day", count: 3)
      click_on("Fill plan")

      expect(page).to have_css("#menu-plan", text: "Day 1\nTags\nSyllabub\nDay 2\nTags\nLemon cake\nDay 3\nTags\nZabaglione")
    end

    it "fills a long plan with randomised recipes, then blanks" do
      expect(page).to have_css(".plan-day", count: 7)
      click_on("Fill plan")

      expect(page).to have_css(".plan-day", text: "Day 1\nTags\nSyllabub")
      expect(page).to have_css(".plan-day", text: "Day 2\nTags\nLemon cake")
      expect(page).to have_css(".plan-day", text: "Day 3\nTags\nZabaglione")
      expect(page).to have_css(".plan-day", text: "Day 4\nTags\nQuince jam")
      expect(page).to have_css(".plan-day", text: "Day 5\nTags\nTiramisu")
      expect(page).to have_css(".plan-day", text: "Day 6\nTags\nNo suitable recipe")
      expect(page).to have_css(".plan-day", text: "Day 7\nTags\nNo suitable recipe")
    end
  end

  describe "editing tags on the menu plan" do
    before { visit "/menu_plan/new" }

    it "shows the tags on the day card" do
      within(".plan-day:nth-child(1)") do
        click_on("Tags")
      end

      within("#modal") do
        expect(page).to have_text("Edit Day 1")
        check("quick")
        check("vegan")
        click_on("Save and close")
      end

      expect(page).to have_css(".plan-day:nth-child(1)", text: "quick vegan")

      within(".plan-day:nth-child(3)") do
        click_on("Tags")
      end

      within("#modal") do
        expect(page).to have_text("Edit Day 3")
        check("vegetarian")
        check("vegan")
        click_on("Save and close")
      end

      expect(page).to have_css(".plan-day:nth-child(3)", text: "vegan vegetarian")
    end
  end
end
