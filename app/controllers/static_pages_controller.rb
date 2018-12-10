class StaticPagesController < ApplicationController
  
  def home
    # current_user exists only if the user is logged in, so the 
    # @micropost & @feed_items variables should only be defined in this case
    if logged_in?
      @micropost  = current_user.microposts.build # Add a micropost instance variable to the home action
      @feed_items = current_user.feed.paginate(page: params[:page]) # Adding a feed instance variable to the home action
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
