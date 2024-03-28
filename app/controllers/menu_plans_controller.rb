class MenuPlansController < ApplicationController
  include Typecasts
  include TagHandling

  before_action :authenticate_user!
  before_action :load_tags, only: %i[edit_tags]

  def new
    build_blank_plan
  end

  def update_plan
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

  def build_blank_plan
    @days = params.dig(:num_days)&.to_i || 7
    @meals = [Recipe.new(name: "")] * @days
    @day_tags = [[1, 2]] * @days
  end
end
