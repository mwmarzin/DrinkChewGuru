class UsersController < ApplicationController
  def login
    respond_to do |format|
      format.html # login.html.erb
    end
  end

  def profile
    respond_to do |format|
      format.html # profile.html.erb
    end
  end
end
