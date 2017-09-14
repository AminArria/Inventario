class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: [:sign_in, :authenticate]

  def dashboard
    @sections_public = Section.addresses_count(public: true)
    @sections_private = Section.addresses_count(public: false)

    @dedicated_hosting = DataCenter.stats
  end

  def sign_in
  end

  def authenticate
    if Ldap.authenticate(params[:username], params[:password])
      session[:auth] = { "expires" => DateTime.now + 8.hours }
      redirect_to root_path
    else
      flash.now[:error] = "Error con el usuario o contraseña"
      render :sign_in
    end
  end

  def sign_out
    session.delete(:auth)
    redirect_to sign_in_path
  end
end
