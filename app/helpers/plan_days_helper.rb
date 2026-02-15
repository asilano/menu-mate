module PlanDaysHelper
  def day_name(plan_day)
    plan_day.name.presence || "Day #{plan_day.day_number + 1}"
  end
end
