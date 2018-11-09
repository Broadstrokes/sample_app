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
      log_in @user # helper method from sessions helper
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # same as redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params) # ch 7.3.2 Use of strong parameters
      # handle a successful update
    else
      render 'edit'
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