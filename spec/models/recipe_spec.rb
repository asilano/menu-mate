require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of :multi_day_count }
  it { should validate_numericality_of(:multi_day_count).only_integer.is_greater_than(0) }

  context "uniqueness validation" do
    let(:user) { create(:user) }
    let!(:spag_bol) { create(:recipe, name: "Spaghetti Bolognese", user:) }

    it "prevents creation of a recipe with the same name and for the same user" do
      duplicate = build(:recipe, name: "Spaghetti Bolognese", user:)

      expect(duplicate.valid?).to be false
    end

    it "allows creation of a recipe with the same name for a different user" do
      duplicate = build(:recipe, name: "Spaghetti Bolognese")

      expect(duplicate.valid?).to be true
    end
  end
end
