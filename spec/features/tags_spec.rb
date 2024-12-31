# frozen_string_literal: true

require "rails_helper"

RSpec.feature "tags", js: true do
  let(:user) { create(:user) }
  let!(:vegetarian) { create(:tag, user:, name: "vegetarian") }
  let!(:quick) { create(:tag, user:, name: "quick") }
  let!(:vegan) { create(:tag, user:, name: "vegan") }

  before do
    allow(Current).to receive(:user).and_return(user)
  end

  describe "on the tags index page" do
    it "lists the tags alphabetically" do
      visit "/tags"
      expect(page).to have_css(".tag:nth-of-type(2) .name", text: "quick")
      expect(page).to have_css(".tag:nth-of-type(3) .name", text: "vegan")
      expect(page).to have_css(".tag:nth-of-type(4) .name", text: "vegetarian")
    end

    it "lets you add tags, inserting them alphabetically" do
      visit "/tags"
      click_link "Add new tag"

      within("#modal") do
        expect(page).to have_text("New Tag")
      end
      fill_in("Name", with: "chicken")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".tag:nth-of-type(2) .name", text: "chicken")

      click_link "Add new tag"
      click_on("Save and close")

      expect(page).to have_css("#modal #error_explanation")

      fill_in("Name", with: "pork")
      click_on("Save and add another")

      expect(page).to have_css(".tag:nth-of-type(3) .name", text: "pork")

      fill_in("Name", with: "fish")
      click_on("Save and close")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css(".tag:nth-of-type(3) .name", text: "fish")
    end

    it "lets you edit and destroy tags" do
      visit "/tags"

      find("##{dom_id(vegetarian, "edit")}").click
      fill_in("Name", with: "chicken")
      click_on("Save")

      expect(page).not_to have_css("#modal div")
      expect(page).to have_css("##{dom_id(vegetarian, "name")}", text: "chicken")

      find("##{dom_id(quick, "edit")}").click
      fill_in("Name", with: "")
      click_on("Save")

      expect(page).to have_css("#modal #error_explanation")

      find("#modal-close").click
      expect(page).not_to have_css("#modal div")

      accept_alert do
        find("##{dom_id(vegan, "delete")}").click
      end

      expect(page).not_to have_css("##{dom_id(vegan)}")
      expect(Tag.count).to eq 2
    end

    it "previews the tag on the edit modal" do
      visit "/tags"
      click_link "Add new tag"

      within("#modal") do
        expect(page).to have_css(".tag-lozenge", text: "preview")
        fill_in("Name", with: "favourite")
        expect(page).to have_css(".tag-lozenge", text: "favourite")
      end
    end
  end
end
