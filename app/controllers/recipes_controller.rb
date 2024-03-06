class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_turbo_frame, only: [:new]

  def index
    @recipes = current_user.recipes
    @recipe = Recipe.build
  end

  def new
    @recipe = Recipe.build
  end

  def create
    @new_recipe = current_user.recipes.build(recipe_params)

    if @new_recipe.save
      @another = params.has_key?(:another)
      @recipe = Recipe.build
    else
      @recipe = @new_recipe
      render :new
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit([
      :name
    ])
  end

  def ensure_turbo_frame
    redirect_to recipes_path unless turbo_frame_request?
  end
end
