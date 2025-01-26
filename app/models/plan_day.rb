class PlanDay < ApplicationRecord
  belongs_to :menu_plan
  belongs_to :recipe, optional: true
  has_one :user, through: :menu_plan
  has_many :plan_day_restrictions, dependent: :destroy
  has_many :tags, through: :plan_day_restrictions

  validates :day_number, numericality: { integer_only: true, greater_than_or_equal: 0 }, uniqueness: { scope: :menu_plan }

  def candidate_recipes
    Recipe.find_by_sql(["
    SELECT * FROM recipes WHERE recipes.user_id = ? AND NOT EXISTS (
      SELECT * FROM plan_day_restrictions LEFT OUTER JOIN recipe_properties
      ON recipe_properties.tag_id = plan_day_restrictions.tag_id
      AND recipe_properties.recipe_id = recipes.id
      WHERE plan_day_restrictions.plan_day_id = ?
      AND recipe_properties.id IS NULL
    )
    ", user.id, id])
  end
end
