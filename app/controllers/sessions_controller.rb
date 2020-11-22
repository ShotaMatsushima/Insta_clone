class SessionsController < ApplicationController
 
  def new
  end
  
  def create
    user=User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
       flash[:success]="ログインしました"
       login user
       params[:session][:remember_me] == '1' ? remember(user) : forget(user)
       redirect_to user
    else
       flash.now[:danger] = 'Eメールもしくはパスワードが間違っています'
       render 'new'
    end
  end
  
  def destroy
    logout if logged_in?
    flash[:success]="ログアウトしました"
    redirect_to login_path
  end
end
