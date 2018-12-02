class PasswordResetsController < ApplicationController
  # Because the existence of a valid @user is needed in both the edit and update 
  # actions, we’ll put the code to find and validate it in a couple of before filters
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # case (1)
  
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
  
  # To define this update action, we need to consider four cases:
    # (1) An expired password reset
    # (2) A failed update due to an invalid password
    # (3) A failed update (which initially looks “successful”) due to an empty password and confirmation
    # (4) A successful update

  def update
    if params[:user][:password].empty? # case (3)
      @user.errors.add(:password, 'cannot be empty')
      render 'edit'
    elsif @user.update_attributes(user_params) # case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit' # case (2)
    end
  end


  private
  
    # Method permitting both the password and password confirmation attributes
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user
    def valid_user
      unless(@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # Checks expiration of reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
