class Leftover < ApplicationRecord
  include ColourUtils

  belongs_to :user
  has_many :leftovers_sources, dependent: :destroy
  has_many :leftovers_sinks, dependent: :destroy

  validates :name, presence: true
  validates :colour, format: /\A#(?:[A-F0-9]{3}){1,2}\z/i
end
