# frozen_string_literal: true

require "rails_helper"

RSpec.feature "recipes", js: true do
  let(:user) { create(:user) }
  let!(:zabaglione) { create(:recipe, user:, name: "Zabaglione") }
  let!(:quince_jam) { create(:recipe, user:, name: "Quince jam") }
  let!(:lemon_cake) { create(:recipe, user:, name: "Lemon cake") }
  let!(:quick_tag) { create(:tag, user:, name: "quick") }
  let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
  let!(:vegan_tag) { create(:tag, user:, name: "vegan") }

  before do
    allow(Current).to receive(:user).and_return(user)
  end

  describe "on the recipes index page" do
    it "lists the recipes" do
      visit "/recipes"
      expect(page).to have_css(".recipe:nth-child(2) .name", text: "Zabaglione")
      expect(page).to have_css(".recipe:nth-child(3) .name", text: "Quince jam")
      expect(page).to have_css(".recipe:nth-child(4) .name", text: "Lemon cake")
    end

    it "lets you add recipes" do
      visit "/recipes"
      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end
      fill_in("Name", with: "Venison stew")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".recipe:last-child .name", text: "Venison stew")

      click_link "Add new recipe"
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation")

      fill_in("Name", with: "Macaroni cheese")
      click_on("Save and add another")

      expect(page).to have_css(".recipe:last-child .name", text: "Macaroni cheese")

      fill_in("Name", with: "Apple pie")
      check("quick")
      check("vegan")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".recipe:last-child .name", text: "Apple pie")

      find("##{dom_id(Recipe.last, "edit")}").click
      expect(page).to have_checked_field("quick")
      expect(page).to have_checked_field("vegan")
      expect(page).to have_unchecked_field("vegetarian")
    end

    it "lets you edit and destroy recipes" do
      visit "/recipes"

      find("##{dom_id(zabaglione, "edit")}").click
      fill_in("Name", with: "Venison stew")
      check("vegetarian")
      check("vegan")
      click_on("Save")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css("##{dom_id(zabaglione, "name")}", text: "Venison stew")

      find("##{dom_id(zabaglione, "edit")}").click
      expect(page).to have_unchecked_field("quick")
      expect(page).to have_checked_field("vegan")
      expect(page).to have_checked_field("vegetarian")

      # Close the modal
      find("#modal-close").click
      expect(page).not_to have_css("#modal div")

      find("##{dom_id(lemon_cake, "edit")}").click
      fill_in("Name", with: "")
      click_on("Save")

      expect(page).to have_css("#modal #error_explanation")

      find("#modal-close").click
      expect(page).not_to have_css("#modal div")

      accept_alert do
        find("##{dom_id(quince_jam, "delete")}").click
      end

      expect(page).not_to have_css("##{dom_id(quince_jam)}")
      expect(Recipe.count).to eq 2
    end
  end
end
