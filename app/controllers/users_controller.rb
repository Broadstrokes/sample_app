class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # same as User.find(1)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save # returns true or false
      # handle successful save
    else
      render 'new'
    end
  end
end