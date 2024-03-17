class MenuPlansController < ApplicationController
  def new
    build_blank_plan
  end

  def build
    build_blank_plan
  end

  private

  def build_blank_plan
    @days = params.dig(:num_days)&.to_i || 7
  end
end
