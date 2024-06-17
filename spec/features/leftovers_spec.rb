# frozen_string_literal: true

require "rails_helper"

RSpec.feature "leftovers", js: true do
  let(:user) { create(:user) }
  let!(:chicken) { create(:leftover, user:, name: "chicken") }
  let!(:beef) { create(:leftover, user:, name: "beef") }

  before do
    allow(Current).to receive(:user).and_return(user)
  end

  describe "on the tags index page" do
    it "lists the leftover kinds" do
      visit "/tags"
      expect(page).to have_css(".leftover:nth-of-type(2) .name", text: "beef")
      expect(page).to have_css(".leftover:nth-of-type(3) .name", text: "chicken")
    end

    it "lets you add leftover sources" do
      visit "/tags"
      click_link "Add new leftover"

      within("#modal") do
        expect(page).to have_text("New Leftover")
      end
      fill_in("Kind", with: "pork")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".leftover:last-child .name", text: "pork")

      click_link "Add new leftover"
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation")

      fill_in("Kind", with: "pork")
      click_on("Save and add another")

      expect(page).to have_css(".leftover:last-child .name", text: "pork")

      fill_in("Kind", with: "fish")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".leftover:last-child .name", text: "fish")
    end

    it "lets you edit and destroy leftovers" do
      visit "/tags"

      find("##{dom_id(chicken, "edit")}").click
      fill_in("Kind", with: "pork")
      click_on("Save")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css("##{dom_id(chicken, "name")}", text: "pork")

      find("##{dom_id(beef, "edit")}").click
      fill_in("Kind", with: "")
      click_on("Save")

      expect(page).to have_css("#modal #error_explanation")

      find("#modal-close").click
      expect(page).not_to have_css("#modal div")

      accept_alert do
        find("##{dom_id(beef, "delete")}").click
      end

      expect(page).not_to have_css("##{dom_id(beef)}")
      expect(Leftover.count).to eq 1
    end
  end
end
