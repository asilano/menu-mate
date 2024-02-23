module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
    helper_method :current_user
    helper_method :user_signed_in?
  end

  def login(user)
    reset_session
    active_session = user.active_sessions.create!
    session[:current_active_session_id] = active_session.id
  end

  def logout
    active_session = ActiveSession.find_by(id: session[:current_active_session_id])
    reset_session
    active_session&.destroy!
  end

  def redirect_if_authenticated
    redirect_to root_path if user_signed_in?
  end

  def authenticate_user!
    store_location
    redirect_to root_path unless user_signed_in?
  end

  private

  def current_user
    Current.user ||= session[:current_active_session_id] &&
      ActiveSession.find_by(id: session[:current_active_session_id]).user
  end

  def user_signed_in?
    Current.user.present?
  end

  def store_location
    session[:user_return_to] = request.original_url if request.get? && request.local?
  end
end
