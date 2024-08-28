class LeftoversSink < ApplicationRecord
  belongs_to :recipe
  belongs_to :leftover
end
