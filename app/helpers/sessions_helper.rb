module SessionsHelper
  
  #セッションにログインユーザーIDを代入(ログイン処理)
  def login(user)
    session[:user_id]=user.id
  end
  
  def remember(user)
    user.remember_db
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
  end
  
  #セッションにあるユーザーIDを代入(現在ログインしているユーザーID)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  #ログインしているか判断する(current_userにnilがあるか)
  def logged_in?
    !current_user.nil?
  end
  
  # 永続的セッションを破棄する
  def forget(user)
    user.forget_db
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def logout
    forget(current_user)
    session.delete(:user_id)
    @current_user=nil
  end
  
  
end
