# frozen_string_literal: true

module StreamActions
  module RemoveClassHelper
    def remove_class(target, classes)
      turbo_stream_action_tag(:remove_class, target: target, class: classes)
    end

    def remove_class_all(targets, classes)
      turbo_stream_action_tag(:remove_class, targets: targets, class: classes)
    end
  end
end

Turbo::Streams::TagBuilder.prepend(StreamActions::RemoveClassHelper)
