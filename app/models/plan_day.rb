class PlanDay < ApplicationRecord
  belongs_to :menu_plan
  belongs_to :recipe, optional: true
  has_one :user, through: :menu_plan
  has_many :plan_day_restrictions, dependent: :destroy
  has_many :tags, through: :plan_day_restrictions

  validates :day_number, numericality: { integer_only: true, greater_than_or_equal: 0 }, uniqueness: { scope: :menu_plan }

  def candidate_recipes
    # Find recipes where:
    # * there are no permissive tags on this day which are not present on the recipe; and
    # * there are no restrictive tags on the recipe which are not present on this day
    Recipe.find_by_sql(["
    SELECT * FROM recipes WHERE recipes.user_id = ? AND NOT EXISTS (
      SELECT * FROM plan_day_restrictions LEFT OUTER JOIN recipe_properties
      ON recipe_properties.tag_id = plan_day_restrictions.tag_id
      AND recipe_properties.recipe_id = recipes.id
      INNER JOIN tags on plan_day_restrictions.tag_id = tags.id
      WHERE plan_day_restrictions.plan_day_id = ?
      AND tags.restrictive is false
      AND recipe_properties.id IS NULL
    )
    AND NOT EXISTS (
      SELECT * FROM recipe_properties LEFT OUTER JOIN plan_day_restrictions
      ON recipe_properties.tag_id = plan_day_restrictions.tag_id
      AND plan_day_restrictions.plan_day_id = ?
      INNER JOIN tags on recipe_properties.tag_id = tags.id
      WHERE recipe_properties.recipe_id = recipes.id
      AND tags.restrictive is true
      AND plan_day_restrictions.id IS NULL
    )
    ", user.id, id, id])
  end
end
