class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy

  def fill
    plan_days.each.with_object({ used_ids: [], leftovers: {}, multi_day_followups: [] }) do |plan_day, state|
      if state[:multi_day_followups].present?
        plan_day.update(recipe: state[:multi_day_followups].pop)
        next
      end

      candidates = plan_day.candidate_recipes.reject { |r| state[:used_ids].include?(r.id) }
      candidates = filter_for_leftovers(candidates, state[:leftovers])

      meal = candidates.sample
      plan_day.update(recipe: meal)

      update_state(state, meal)
    end
  end

  private

  def filter_for_leftovers(candidates, leftover_state)
    leftover_filtered_candidates = candidates.select do |candidate|
      candidate.leftovers_sink&.leftover_id &&
        leftover_state[candidate.leftovers_sink.leftover_id] &&
        leftover_state[candidate.leftovers_sink.leftover_id] > 0
    end

    return leftover_filtered_candidates unless leftover_filtered_candidates.empty?

    candidates
  end

  def update_state(state, meal)
    if meal
      state[:used_ids] << meal.id

      if meal.leftovers_source
        state[:leftovers][meal.leftovers_source.leftover.id] ||= 0
        state[:leftovers][meal.leftovers_source.leftover.id] += meal.leftovers_source.num_days
      end

      if meal.leftovers_sink && state[:leftovers][meal.leftovers_sink.leftover.id]
        state[:leftovers][meal.leftovers_sink.leftover.id] -= 1

        if state[:leftovers][meal.leftovers_sink.leftover.id] == 0
          state[:leftovers].delete(meal.leftovers_sink.leftover.id)
        end
      end

      if meal.multi_day_count > 1
        state[:multi_day_followups].concat([meal] * (meal.multi_day_count - 1))
      end
    end
  end
end
