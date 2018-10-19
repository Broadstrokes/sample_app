class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # same as User.find(1)
  end
  
  def new
  end
end
