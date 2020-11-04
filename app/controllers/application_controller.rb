class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private

    def logged_in_user
      unless logged_in?
        flash[:dacger]="ログインしてください"
        redirect_to root_url
      end
    end
end
