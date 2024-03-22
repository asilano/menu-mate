module ApplicationHelper
  def controller_based_title
    case controller_name
    in "recipes"
      "Menu Mate - Recipes"
    in "menu_plans"
      "Menu Mate - Menu Plan"
    else
      "Menu Mate"
    end
  end
end
