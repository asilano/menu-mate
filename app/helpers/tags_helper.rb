module TagsHelper
  def tag_colours_css(tag)
    "background-color: #{tag.colour};
     color: #{tag.contrast_color}"
  end

  def tag_display_name(meal_tag)
    lead = tag.span("×", class: "restrictive-indicator") if meal_tag.restrictive
    (lead || "".html_safe) + tag.span(meal_tag.name.presence || "preview", class: "tag-name")
  end
end
