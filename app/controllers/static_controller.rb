class StaticController < ApplicationController
  def root
    @suppress_autologin = flash[:suppress_autologin]
  end
end
