class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy

  def fill
    plan_days.each.with_object({ used_ids: [], leftovers: {} }) do |plan_day, state|
      candidates = plan_day.candidate_recipes
      meal = candidates.reject { |r| state[:used_ids].include?(r.id) }.sample
      plan_day.update(recipe: meal)
      state[:used_ids] << meal.id if meal
      if meal && meal.leftovers_source
        state[:leftovers][meal.leftovers_source.leftover.id] ||= 0
        state[:leftovers][meal.leftovers_source.leftover.id] += meal.leftovers_source.num_days
      end
    end
  end
end
