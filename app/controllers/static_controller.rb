class StaticController < ApplicationController
  before_action :require_authentication, only: []

  def root
    @suppress_autologin = flash[:suppress_autologin]
    @root_page = true
  end
end
