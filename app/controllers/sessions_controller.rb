class SessionsController < ApplicationController
  skip_before_action :force_authentication, only: [:unauthenticated, :signin_get, :signin_post]

  def unauthenticated
    render :unauthenticated
  end

  def signin_get
    if is_authenticated
      redirect_to root_path
    else
      render :signin
    end
  end

  def signin_post
    user = User.where("username = ? OR email = ? AND password = ?", sessions_params[:email], sessions_params[:email], encrypt_password(sessions_params[:password])).first

    if user
      session[:current_user_id] = user.id

      respond_to do |format|
        format.json { render :success }
      end
    else
      session[:current_user_id] = nil

      respond_to do |format|
        format.json { render :error }
      end
    end
  end

  def signout
    session[:current_user_id] = nil

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

    def sessions_params
      params.require(:user).permit(:email, :password)
    end

    def encrypt_password(password = nil)
      return Digest::SHA2::hexdigest(sessions_params[:password])
    end

end