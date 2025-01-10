module ColourUtils
  extend ActiveSupport::Concern

  def contrast_color
    ColorConversion::Color.new(colour).rgb => {r:, g:, b:}
    luma = r * 0.299 + g * 0.587 + b * 0.114

    if luma > 179
      "var(--black)"
    else
      "var(--white)"
    end
  end
end
