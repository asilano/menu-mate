require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TagsHelper. For example:
#
# describe TagsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TagsHelper, type: :helper do
  describe "#tag_display_name" do
    let(:preview_tag) { build(:tag, name: "") }
    let(:permissive_tag) { build(:tag, name: "quick") }
    let(:restrictive_tag) { build(:tag, name: "slow", restrictive: true) }

    it "returns the name on a permissive tag as a span" do
      expect(tag_display_name(permissive_tag)).to eq '<span class="tag-name">quick</span>'
    end

    it "returns the name prefixed with a cross on a restrictive tag" do
      expect(tag_display_name(restrictive_tag)).to eq '<span class="restrictive-indicator">×</span><span class="tag-name">slow</span>'
    end

    it "returns 'preview' on an unnamed tag" do
      expect(tag_display_name(preview_tag)).to eq '<span class="tag-name">preview</span>'
    end
  end
end
