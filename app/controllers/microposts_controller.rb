class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

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
  end

  private
   
    # Permits only the micropost’s content attribute to be modified through the web
    def micropost_params
      params.require(:micropost).permit(:content)
    end
    
end
