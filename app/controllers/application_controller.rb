class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  private
  def require_login
    if session[:auth].nil? || session[:auth]["expires"] < DateTime.now
      redirect_to sign_in_path
    end
  end
end
