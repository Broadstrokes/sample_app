class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) # same as User.find(1)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save # returns true or false
      # handle successful save
    else
      render 'new'
    end
  end
  
  private 
    
    def user_params
      # This code returns a version of the params hash with only
      # the permitted attributes (while raising an error if the 
      # :user attribute is missing)
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end
end