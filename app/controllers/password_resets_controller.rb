class PasswordResetsController < ApplicationController
  # Because the existence of a valid @user is needed in both the edit and update 
  # actions, we’ll put the code to find and validate it in a couple of before filters
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if (@user)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email not found"
      render 'new'
    end
  end

  def edit
  end


  private
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user
    def valid_user
      unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
end
