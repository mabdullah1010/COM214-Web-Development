class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  private

  def require_login
    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
end
