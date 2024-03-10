class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_turbo_frame, only: [:new]
  before_action :load_recipe, only: [:destroy] # %i[edit update destroy]

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

  def destroy
    return redirect_to action: :index unless @recipe
    @recipe.destroy
  end

  private

  def load_recipe
    @recipe = current_user.recipes.find_by(id: params[:id])
  end

  def recipe_params
    params.require(:recipe).permit([
      :name
    ])
  end

  def ensure_turbo_frame
    redirect_to recipes_path unless turbo_frame_request?
  end
end
