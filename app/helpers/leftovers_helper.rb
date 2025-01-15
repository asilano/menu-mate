module LeftoversHelper
  def leftover_colours_css(leftover)
    "background-color: #{leftover.contrast_color};
      color: #{leftover.colour}"
  end
end
