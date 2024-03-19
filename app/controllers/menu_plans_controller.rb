class MenuPlansController < ApplicationController
  include Typecasts

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

  private

  def build_blank_plan
    @days = params.dig(:num_days)&.to_i || 7
  end
end
