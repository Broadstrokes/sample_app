class StaticPagesController < ApplicationController
  
  def home
    # Add a micropost instance variable to the home action
    # current_user exists only if the user is logged in, so the 
    # @micropost variable should only be defined in this case
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
