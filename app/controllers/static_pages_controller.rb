class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      redirect_to signup_path
    end
  end

end
