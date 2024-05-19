class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy

  def fill
    meals = user.recipes.shuffle
    plan_days.each.with_index do |plan_day, ix|
      plan_day.update(recipe: meals[ix])
    end

    # plan_days.each do |plan_day|
    #   # candidates = user.meals.where(tag)
    #   plan_day.update(recipe: meals[ix])
    # end
  end
end
