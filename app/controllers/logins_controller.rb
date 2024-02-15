class LoginsController < ApplicationController
  before_action :validate_google_csrf, only: :google

  def new
  end

  def google
    @google_account_info = Google::Auth::IDTokens.verify_oidc(
      params[:credential],
      aud: Rails.application.credentials.google_sign_in.client_id
    )
    google_userid = @google_account_info["sub"]

    user = User.find_by(google_userid:)
    if user
      flash.notice = "Found existing user id #{user.id}"
      user.update_from @google_account_info
    else
      user = User.create_from @google_account_info
      if user
        flash.notice = "Created new user id #{user.id}"
      else
        flash.alert = "Failed to create user"
      end
    end

    redirect_to :root
  end

  private

  def validate_google_csrf
    # Google Sign In provides its own csrf token and stores it in the cookie along with including it in the request
    if cookies["g_csrf_token"].blank? || params["g_csrf_token"].blank? || cookies["g_csrf_token"] != params["g_csrf_token"]
      raise ActionController::InvalidAuthenticityToken
    end
  end
end
