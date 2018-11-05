class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # log the user & redirect to users who page
      log_in @user
      
      # remember session using the session helper method remember
      # NB: this method is not the same as the User.remember method
      # this method calls the User.remember method inside it
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      
      # NB: the compact redirect redirect_to user
      # Rails automatically converts this to the route for the 
      # user’s profile page: user_url(user)
      redirect_to @user
    else 
      # create an error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
 