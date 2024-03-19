module Typecasts
  extend ActiveSupport::Concern

  def cast_to_bool(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
