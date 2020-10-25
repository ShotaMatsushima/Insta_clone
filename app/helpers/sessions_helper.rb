module SessionsHelper
  
  #セッションにログインユーザーIDを代入(ログイン処理)
  def login(user)
    session[:user_id]=user.id
  end
  
  #セッションにあるユーザーIDを代入(現在ログインしているユーザーID)
  def current_user
    if session[:user_id]
      @current_user ||=User.find_by(id: session[:user_id])
    end
  end
  
  #ログインしているか判断する(current_userにnilがあるか)
  def logged_in?
    !current_user.nil?
  end
  
  def logout
    session.delete(:user_id)
    @current_user=nil
  end
end
