class StaticPagesController < ApplicationController
  def home
    if logged_in?
     @feed_items = current_user.feed.paginate(page: params[:page])
    else
    redirect_to login_path
    end
  end

  def help
  end
  
  def about
  end
end
