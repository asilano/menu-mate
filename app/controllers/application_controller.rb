class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern
  include Authentication
  include Typecasts

  def ensure_turbo_frame(fallback)
    redirect_to fallback unless turbo_frame_request?
  end
end
