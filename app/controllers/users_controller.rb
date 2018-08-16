class UsersController < ApplicationController
  before_action :load_users

  def index
    gon.users = User.all
  end

  def new
    @user = User.new
  end

  def create
   @max_id = 0;
    @users.each do |user|
      if @max_id < user["id"].to_i
        @max_id = user["id"].to_i
      end
    end

    # obj_new ={}
    # obj_new["id"] = (@max_id + 1).to_s
    # obj_new["name"] = params[:user][:name]
    # obj_new["email"] = params[:user][:email]
    # obj_new["passwordDigest"] = Digest::MD5.hexdigest(params[:user][:password])
    @obj_new = User.new
    @obj_new.id = (@max_id + 1).to_s
    @obj_new.name = params[:user][:name]
    @obj_new.email = params[:user][:email]
    @obj_new.password_digest = Digest::MD5.hexdigest(params[:user][:password])

    @users << @obj_new
    write_user_xml
    Dir.mkdir "lib/xml/user#{@obj_new.id}"
    Dir.mkdir "lib/xml/user#{@obj_new.id}/test_suites"
    Dir.mkdir "lib/xml/user#{@obj_new.id}/layout"
    Dir.mkdir "lib/xml/user#{@obj_new.id}/report"
    log_in @obj_new
    redirect_to root_path
  end

  # def create
  #   @user = User.new user_params
  #   if @user.save
  #     Dir.mkdir "lib/xml/user#{@user.id}"
  #     Dir.mkdir "lib/xml/user#{@user.id}/test_suites"
  #     Dir.mkdir "lib/xml/user#{@user.id}/layout"
  #     Dir.mkdir "lib/xml/user#{@user.id}/report"
  #     flash[:success] = "Welcome to the End Test!"
  #     log_in @user
  #     redirect_to root_url
  #   else
  #     render :new
  #   end
  # end

  def write_user_xml
    write_user = Nokogiri::XML::Builder.new(encoding: "UTF-8") do |xml|
      xml.users {
        @users.each do |us|
          xml.user{
            xml.id us.id
            xml.name us.name
            xml.email us.email
            xml.passwordDigest us.password_digest
          }
        end
      }
    end

    File.open("lib/xml/users.xml", "w+") do |file|
      file << write_user.to_xml
    end
  end

  # def user_params
  #   params.require(:user).permit :name, :email, :password
  # end

  # def load_user
  #   @user = User.find_by id: params[:id]
  #   @user || render(file: "public/404.html", status: 404, layout: true)
  # end
end
