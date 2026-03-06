module MenuPlansHelper
  def selected_auto_day(menu_plan)
    existing = menu_plan.plan_days.first.name
    return existing if I18n.t("date.day_names").include?(existing)

    Current.user.last_auto_start_day
  end
end
