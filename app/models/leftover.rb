class Leftover < ApplicationRecord
  belongs_to :user
  has_many :leftovers_sources, dependent: :destroy
  has_many :leftovers_sinks, dependent: :destroy

  validates :name, presence: true
end
