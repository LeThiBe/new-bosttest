class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to root_path
    else
      flash.now[:danger] = t "sessions.create.invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
