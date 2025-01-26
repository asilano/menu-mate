require 'rails_helper'

RSpec.describe Leftover, type: :model do
  subject(:leftover) { build(:leftover, name: "algae") }

  it { should allow_value("#aF09Db").for :colour }
  it { should allow_value("#89a").for :colour }
  it { should_not allow_value("#0aF09Db").for :colour }
  it { should_not allow_value("#F09Db").for :colour }
  it { should_not allow_value("#G0089a").for :colour }

  context "uniqueness validation" do
    let(:user) { create(:user) }
    let!(:beef) { create(:leftover, name: "beef", user:) }

    it "prevents creation of a leftover with the same name and for the same user" do
      duplicate = build(:leftover, name: "beef", user:)

      expect(duplicate.valid?).to be false
    end

    it "allows creation of a leftover with the same name for a different user" do
      duplicate = build(:leftover, name: "beef")

      expect(duplicate.valid?).to be true
    end
  end
end
