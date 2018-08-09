class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
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
