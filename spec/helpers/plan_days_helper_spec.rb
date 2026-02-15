require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PlanDaysHelper. For example:
#
# describe PlanDaysHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe PlanDaysHelper, type: :helper do
  describe "day_name" do
    subject { day_name(plan_day) }

    context "when the day has no name" do
      let(:plan_day) { build(:plan_day, day_number: 3) }

      it "returns the day number" do
        expect(subject).to eq "Day 4"
      end
    end
  end
end
