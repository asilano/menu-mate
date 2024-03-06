# frozen_string_literal: true

module StreamActions
  module DispatchHelper
    def dispatch(name, target: nil, detail: {})
      turbo_stream_action_tag(:dispatch, name:, target:, detail: detail.to_json)
    end
  end
end

Turbo::Streams::TagBuilder.prepend(StreamActions::DispatchHelper)
