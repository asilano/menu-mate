require 'rails_helper'

RSpec.describe Tag, type: :model do
  subject(:tag) { build(:tag, name: "acidic") }

  it { should allow_value("#aF09Db").for :colour }
  it { should allow_value("#89a").for :colour }
  it { should_not allow_value("#0aF09Db").for :colour }
  it { should_not allow_value("#F09Db").for :colour }
  it { should_not allow_value("#G0089a").for :colour }

  context "uniqueness validation" do
    let(:user) { create(:user) }
    let!(:quick) { create(:tag, name: "quick", user:) }

    it "prevents creation of a tag with the same name and for the same user" do
      duplicate = build(:tag, name: "quick", user:)

      expect(duplicate.valid?).to be false
    end

    it "allows creation of a tag with the same name for a different user" do
      duplicate = build(:tag, name: "quick")

      expect(duplicate.valid?).to be true
    end
  end
end
