class LoginsController < ApplicationController
  before_action :redirect_if_authenticated, only: :google
  before_action :validate_google_csrf, only: :google

  def google
    @google_account_info = Google::Auth::IDTokens.verify_oidc(
      params[:credential],
      aud: Rails.application.credentials.google_sign_in.client_id
    )
    google_userid = @google_account_info["sub"]

    user = User.find_by(google_userid:)
    if user
      user.update_from @google_account_info
    else
      user = User.create_from @google_account_info
    end

    after_login_path = :root
    if user&.persisted?
      after_login_path = session[:user_return_to] || :root
      login user
    end

    redirect_to after_login_path
  end

  def destroy
    logout
    flash[:suppress_autologin] = true
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
