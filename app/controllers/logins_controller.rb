class LoginsController < ApplicationController
  before_action :validate_google_csrf, only: :create

  def new
  end

  def create
    @google_account_info = Google::Auth::IDTokens.verify_oidc(
      params[:credential],
      aud: Rails.application.credentials.google_sign_in.client_id
    )
  end

  private

  def validate_google_csrf
    # Google Sign In provides its own csrf token and stores it in the cookie along with including it in the request
    if cookies["g_csrf_token"].blank? || params["g_csrf_token"].blank? || cookies["g_csrf_token"] != params["g_csrf_token"]
      raise ActionController::InvalidAuthenticityToken
    end
  end
end
