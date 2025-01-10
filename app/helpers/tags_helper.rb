module TagsHelper
  def tag_colours_css(tag)
    "background-color: #{tag.colour};
     color: #{tag.contrast_color}"
  end
end
