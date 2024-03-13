# frozen_string_literal: true

require "rails_helper"

RSpec.feature "root requests", js: true do
  describe "home page and links" do
    let(:user) { create(:user) }

    before do
      allow(Current).to receive(:user).and_return(user)
    end

    it "all the links work" do
      visit "/"
      click_link "Recipe Collection"

      expect(page).to have_content "Recipes"
      expect(page).to have_link "Add new recipe"

      page.find("a.menu-button").click
      click_link("Home")

      expect(current_path).to eq "/"
    end
  end
end
