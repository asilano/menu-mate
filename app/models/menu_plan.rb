class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy

  def fill
    plan_days.each.with_object([]) do |plan_day, used_ids|
      candidates = plan_day.candidate_recipes
      meal = candidates.reject { |r| used_ids.include?(r.id) }.sample
      plan_day.update(recipe: meal)
      used_ids << meal.id if meal
    end
  end
end
