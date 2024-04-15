class MenuPlansController < ApplicationController
  include Typecasts
  include TagHandling

  before_action :authenticate_user!
  before_action :load_menu_plan, except: :new
  before_action :load_tags, only: %i[edit_tags]

  def new
    current_user.create_menu_plan
    redirect_to action: :edit
  end

  def edit
    build_blank_plan
  end

  def update
    build_blank_plan
    unless cast_to_bool(params[:blank_plan])
      @meals = current_user.recipes.shuffle[0..@days]
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit_tags
    @day = params[:day].to_i
  end

  private

  def load_menu_plan
    @menu_plan = current_user.menu_plan
  end

  def build_blank_plan
    @days = params.dig(:menu_plan, :num_days)&.to_i || 7
    @meals = [Recipe.new(name: "")] * @days
    @day_tags = [[1, 2]] * @days
  end
end
