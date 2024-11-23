class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy

  def fill
    plan_days.each.with_object({ used_ids: [], leftovers: {} }) do |plan_day, state|
      candidates = plan_day.candidate_recipes.reject { |r| state[:used_ids].include?(r.id) }

      leftover_filtered_candidates = candidates.select do |candidate|
        candidate.leftovers_sink&.leftover_id &&
          state[:leftovers][candidate.leftovers_sink.leftover_id] &&
          state[:leftovers][candidate.leftovers_sink.leftover_id] > 0
      end

      if !leftover_filtered_candidates.empty?
        candidates = leftover_filtered_candidates
      end

      meal = candidates.sample
      plan_day.update(recipe: meal)

      state[:used_ids] << meal.id if meal
      if meal && meal.leftovers_source
        state[:leftovers][meal.leftovers_source.leftover.id] ||= 0
        state[:leftovers][meal.leftovers_source.leftover.id] += meal.leftovers_source.num_days
      end
    end
  end
end
