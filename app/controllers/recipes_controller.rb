class RecipesController < ApplicationController
  include TagHandling

  before_action :authenticate_user!
  before_action -> { ensure_turbo_frame(recipes_path) }, only: [:new, :edit]
  before_action :load_recipe, only: %i[edit update destroy]
  before_action :load_tags, only: %i[new create edit update]

  def index
    @recipes = current_user.recipes.order(:id)
  end

  def new
    @recipe = Recipe.build
    @recipe.build_leftovers_source
  end

  def create
    @new_recipe = current_user.recipes.build(recipe_params)

    if @new_recipe.save
      @another = params.has_key?(:another)
      @recipe = Recipe.build
      @recipe.build_leftovers_source
    else
      @recipe = @new_recipe
      @recipe.build_leftovers_source unless @recipe.leftovers_source
      render :new
    end
  end

  def edit
    @recipe.build_leftovers_source unless @recipe.leftovers_source
  end

  def update
    if !@recipe.update(recipe_params)
      @recipe.build_leftovers_source unless @recipe.leftovers_source
      render :edit
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
      :name,
      tag_ids: [],
      leftovers_source_attributes: [
        :id,
        :leftover_id,
        :num_days,
        :_destroy
      ]
    ])
  end
end
