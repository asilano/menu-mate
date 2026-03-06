module TagHandling
  extend ActiveSupport::Concern

  def load_tags
    @tags = Current.user.tags.order(:name)
    @leftovers = Current.user.leftovers.order(:name)
  end
end
