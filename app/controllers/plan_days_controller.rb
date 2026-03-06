class PlanDaysController < ApplicationController
  include TagHandling

  before_action :require_authentication
  before_action -> { ensure_turbo_frame(edit_menu_plan_path) }, only: [:edit]
  before_action :load_plan_day
  before_action :load_tags, only: :edit

  def edit
  end

  def update
    if !@plan_day.update(plan_day_params)
      return render :edit
    end

    @close_modal = cast_to_bool(params[:close_modal])

    unless cast_to_bool(params[:redraw_day])
      head :no_content
    end
  end

  private

  def load_plan_day
    @plan_day = Current.user.plan_days.find(params[:id])
  end

  def plan_day_params
    params.require(:plan_day).permit([
      :name,
      tag_ids: []
    ])
  end
end
