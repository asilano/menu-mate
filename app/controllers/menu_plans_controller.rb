class MenuPlansController < ApplicationController
  include Typecasts
  include TagHandling

  before_action :authenticate_user!
  before_action :load_menu_plan, except: :new
  before_action :load_tags, only: %i[edit_tags]

  def new
    MenuPlan.where(user: current_user).destroy_all
    menu_plan = current_user.create_menu_plan

    meals = current_user.recipes.shuffle
    7.times do |n|
      menu_plan.plan_days.create(day_number: n, recipe: meals[n])
    end
    redirect_to action: :edit
  end

  def edit
  end

  def update_number_of_days
    new_day_count = params.dig(:menu_plan, :num_days).to_i || @menu_plan.plan_days.count
    old_day_count = @menu_plan.plan_days.count
    used_recipe_ids = @menu_plan.plan_days.pluck(:recipe_id)

    if old_day_count > new_day_count
      @menu_plan.plan_days.last(old_day_count - new_day_count).each(&:destroy)
      @menu_plan.plan_days.reload
    else
      meals = current_user.recipes.where.not(id: used_recipe_ids).shuffle
      old_day_count.upto(new_day_count - 1) do |n|
        @menu_plan.plan_days.create(day_number: n, recipe: meals[n - old_day_count])
      end
    end

    render "update"
  end

  def fill_recipes
    meals = current_user.recipes.shuffle
    @menu_plan.plan_days.each.with_index do |plan_day, ix|
      plan_day.update(recipe: meals[ix])
    end

    render "update"
  end

  def edit_tags
    @day = params[:day].to_i
  end

  private

  def load_menu_plan
    @menu_plan = current_user.menu_plan
  end
end
