class SessionsController < ApplicationController
  skip_before_action :force_authentication, only: [
    :unauthenticated, :signin_get, :signin_post, :signup_get, :signup_post]

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
    user = User.where("username = ? OR email = ?", sessions_params[:email], sessions_params[:email]).first

    if user and user.authenticate(sessions_params[:password])
      session[:current_user_id] = user.id

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render :success }
      end
    else
      session[:current_user_id] = nil
      flash.now[:errors] = t('message.signin_failed')

      respond_to do |format|
        format.html { render :signin }
        format.json { render :error }
      end
    end
  end

  def signup_get
    if is_authenticated
      redirect_to root_path
    else
      render :signup
    end
  end

  def signup_post
    @user = User.new(sessions_params)

    if @user.save
      flash.now[:success] = t('message.signup_success')

      respond_to do |format|
        format.html { render :signup }
      end
    else
      flash.now[:errors] = @user.errors

      respond_to do |format|
        format.html { render :signup }
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
      params.require(:user).permit(:name, :email, :username, :password, :password_confirmation)
    end

end