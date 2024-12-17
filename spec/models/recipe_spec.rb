require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should validate_presence_of :multi_day_count }
  it { should validate_numericality_of(:multi_day_count).only_integer.is_greater_than(0) }
end
