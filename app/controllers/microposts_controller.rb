class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params) # use of strong parameters via micropost_params
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # on failed micropost submission, the Home page expects an @feed_items 
      # instance variable, so failed submissions will break
      # soltion: suppress the feed entirely by assigning it an empty array
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # Redirect back to the page issuing the delete request
    # We can also use redirect_back(fallback_location: root_url) This method was added in Rails 5
    redirect_to request.referrer || root_url
  end

  private
   
    # Permits only the micropost’s content attribute to be modified through the web
    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    
end
