class StaticController < ApplicationController
  before_action :authenticate_user!, only: []

  def root
    @suppress_autologin = flash[:suppress_autologin]
    @root_page = true
  end
end
