# frozen_string_literal: true

require "rails_helper"

RSpec.feature "recipes", js: true do
  let(:user) { create(:user) }
  let!(:quick_tag) { create(:tag, user:, name: "quick", colour: "#005050") }
  let!(:vegetarian_tag) { create(:tag, user:, name: "vegetarian") }
  let!(:vegan_tag) { create(:tag, user:, name: "vegan") }
  let!(:beef_leftovers) { create(:leftover, user:, name: "beef") }
  let!(:pork_leftovers) { create(:leftover, user:, name: "pork") }
  let!(:zabaglione) { create(:recipe, user:, name: "Zabaglione") }
  let!(:quince_jam) { create(:recipe, user:, name: "Quince jam", tags: [vegetarian_tag, vegan_tag]) }
  let!(:lemon_cake) { create(:recipe, user:, name: "Lemon cake", tags: [quick_tag]) }

  before do
    allow(Current).to receive(:user).and_return(user)
  end

  describe "on the recipes index page" do
    it "lists the recipes alphabetically" do
      visit "/recipes"
      expect(page).to have_css(".recipe:nth-child(2) .name", text: "Lemon cake")
      expect(page).to have_css(".recipe:nth-child(3) .name", text: "Quince jam")
      expect(page).to have_css(".recipe:nth-child(4) .name", text: "Zabaglione")
    end

    it "includes the coloured tags on the recipe line" do
      visit "/recipes"
      expect(page).to have_css(".recipe:nth-child(2) .tags", text: "quick")
      expect(page).to have_css(".recipe:nth-child(3) .tags", text: "vegetarian vegan")
      expect(page).to have_css(".recipe:nth-child(4) .tags", text: "")

      quick_lozenge = page.find(".recipe:nth-child(2) .tags .tag-lozenge")
      expect(quick_lozenge.style("background-color")["background-color"]).to eq "rgb(0, 80, 80)"
      expect(quick_lozenge.style("color")["color"]).to eq "rgb(250, 250, 250)"
    end

    it "lets you add recipes, including errors and tags" do
      visit "/recipes"
      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end
      fill_in("Name", with: "Venison stew")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".recipe:nth-child(4) .name", text: "Venison stew")

      click_link "Add new recipe"
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation")

      fill_in("Name", with: "Macaroni cheese")
      click_on("Save and add another")

      expect(page).to have_css(".recipe:nth-child(3) .name", text: "Macaroni cheese")

      fill_in("Name", with: "Apple pie")
      check("quick")
      check("vegan")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".recipe:nth-child(2) .name", text: "Apple pie")
      expect(page).to have_css(".recipe:nth-child(2) .tags", text: "quick vegan")

      find("##{dom_id(Recipe.last, "edit")}").click
      expect(page).to have_checked_field("quick")
      expect(page).to have_checked_field("vegan")
      expect(page).to have_unchecked_field("vegetarian")
    end

    it "lets you add recipes making leftovers" do
      visit "/recipes"
      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end

      fill_in("Name", with: "Roast beef")
      check("Produces leftovers")
      choose("beef")
      fill_in("For how many days:", with: 3)
      check("vegan")
      click_on("Save and close")

      expect(page).to have_css(".recipe:nth-child(4) .name", text: "Roast beef")
      expect(page).to have_css(".recipe:nth-child(4) .tags", text: "vegan → beef")

      find("##{dom_id(Recipe.last, "edit")}").click
      expect(page).to have_checked_field("vegan")
      expect(page).to have_checked_field("Produces leftovers")
      expect(page).to have_checked_field("beef")
      expect(page).to have_field("For how many days:", with: 3)
      click_on("Cancel")

      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end

      fill_in("Name", with: "Roast pork")
      check("Produces leftovers")
      fill_in("For how many days:", with: 3)
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation", text: "Leftover type must be specified")

      check("Produces leftovers")
      choose("pork")
      fill_in("For how many days:", with: "")
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation", text: "Leftover number of days is not a number")
    end

    it "lets you add recipes using leftovers" do
      visit "/recipes"
      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end

      fill_in("Name", with: "Roast beef")
      check("Uses leftovers")
      choose("beef")
      click_on("Save and close")

      expect(page).to have_css(".recipe:nth-child(4) .name", text: "Roast beef")
      expect(page).to have_css(".recipe:nth-child(4) .tags", text: "← beef")

      find("##{dom_id(Recipe.last, "edit")}").click
      expect(page).to have_checked_field("Uses leftovers")
      expect(page).to have_checked_field("beef")
      click_on("Cancel")

      click_link "Add new recipe"

      within("#modal") do
        expect(page).to have_text("Add Recipe")
      end

      fill_in("Name", with: "Roast pork")
      check("Uses leftovers")
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation", text: "Leftover type must be specified")
    end

    it "lets you edit and destroy recipes" do
      visit "/recipes"

      find("##{dom_id(zabaglione, "edit")}").click
      fill_in("Name", with: "Venison stew")
      check("vegetarian")
      check("vegan")
      check("Produces leftovers")
      choose("pork")
      fill_in("For how many days:", with: 2)
      click_on("Save")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css("##{dom_id(zabaglione, "name")}", text: "Venison stew")

      find("##{dom_id(zabaglione, "edit")}").click
      expect(page).to have_unchecked_field("quick")
      expect(page).to have_checked_field("vegan")
      expect(page).to have_checked_field("vegetarian")
      expect(page).to have_checked_field("Produces leftovers")
      expect(page).to have_checked_field("pork")
      expect(page).to have_field("For how many days:", with: 2)

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
