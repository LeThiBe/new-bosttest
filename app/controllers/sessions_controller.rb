class SessionsController < ApplicationController
  before_action :load_users, only: :create
  before_action :find_user, only: :create

  def new; end

  def create
    if @user&.password_digest == Digest::MD5.hexdigest(params[:session][:password])
      log_in @user
      redirect_to root_path
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def find_user

    @user = User.new
    # @user =  {}

    @users.each do |u|
      if u["email"] == params[:session][:email].downcase
        # @user["id"] = u["id"]
        # @user["name"] = u["name"]
        # @user["email"] = u["email"]
        # @user["password_digest"] = u["passwordDigest"]
        # @user.email = u["email"]
        # @user.password_digest = u["passwordDigest"]
        @user = u
      end
    end
  end

  # def load_user
  #   @user = User.find_by email: params[:session][:email].downcase
  # end
end
