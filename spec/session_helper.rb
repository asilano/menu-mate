module Test
  class SessionsController < ApplicationController
    def create
      vars = params.permit(session_vars: {})
      vars[:session_vars].each do |var, value|
        session[var] = value
      end
      head :created
    end
  end

  module RequestSessionHelper
    def set_session(vars = {})
      post test_session_path, params: { session_vars: vars }
      expect(response).to have_http_status(:created)

      vars.each_key do |var|
        expect(session[var]).to be_present
      end
    end
  end

  module LoginHelper
    def login_as(user)
      active_session = user.active_sessions.create!
      set_session(current_active_session_id: active_session.id)
    end
  end
end

RSpec.configure do |config|
  config.include Test::RequestSessionHelper
  config.include Test::LoginHelper

  config.before(:all, type: :request) do
    # https://github.com/rails/rails/blob/d15a694b40922f15c81042acaeede9e7df7bbb75/actionpack/lib/action_dispatch/routing/route_set.rb#L423
    Rails.application.routes.send(:eval_block, Proc.new do
      namespace :test do
        resource :session, only: %i[create]
      end
    end)
  end
end
