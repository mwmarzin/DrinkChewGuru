class UsersController < ApplicationController
  def login
    respond_to do |format|
      format.html # login.html.erb
    end
  end

  def profile
  end
end
