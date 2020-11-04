class MicropostsController < ApplicationController
  before_action :logged_in_user, only: :new
  before_action :correct_user,   only: :destroy
  
def new
  @micropost=current_user.microposts.build if logged_in?
end

def create
  @micropost=current_user.microposts.build(micropost_params)
  @micropost.image.attach(params[:micropost][:image])
  if @micropost.save
    flash[:success]="投稿しました"
    redirect_to @micropost.user
  else
    @feed_items = []
    render 'new'
  end
end

def destroy
  if @micropost.destroy
    flash[:success]="削除しました"
     redirect_to request.referrer || root_url
  else
    redirect_to root_url
  end
end


private

def micropost_params
  params.require(:micropost).permit(:content, :image)
end

def correct_user
  @micropost = current_user.microposts.find_by(id: params[:id])
  redirect_to root_url if @micropost.nil?
end
end
