class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_users
  include SessionsHelper

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users.logged_in_user.please"
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_users
    doc = Nokogiri::XML(File.open("lib/xml/users.xml"))
    @users = []
    doc.xpath("//user").each do |u|
      obj = User.new
      # obj["id"] = u.at_xpath("id").text
      # obj["name"] = u.at_xpath("name").text
      # obj["email"] = u.at_xpath("email").text
      # obj["passwordDigest"] = u.at_xpath("passwordDigest").text
      obj.id = u.at_xpath("id").text
      obj.name = u.at_xpath("name").text
      obj.email = u.at_xpath("email").text
      obj.password_digest = u.at_xpath("passwordDigest").text
      @users << obj
    end
  end

  def load_testsuites
    xml = Nokogiri::XML(File.open("lib/xml/test_suites.xml"))
    @testsuits = []
    xml.xpath("//testsuite").each do |ts|
      obj = {}
      obj["id"] = ts.at_xpath("id").text
      obj["name"] = ts.at_xpath("name").text
      @testsuits << obj
    end
  end
end
