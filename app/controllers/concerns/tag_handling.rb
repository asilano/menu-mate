module TagHandling
  extend ActiveSupport::Concern

  def load_tags
    @tags = current_user.tags
  end
end