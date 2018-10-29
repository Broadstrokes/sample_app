class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # log the user & redirect to users who page
      log_in(user)
      
      # NB: the compact redirect redirect_to user
      # Rails automatically converts this to the route for the 
      # user’s profile page: user_url(user)
      redirect_to user
    else 
      # create an error message
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end

end
 