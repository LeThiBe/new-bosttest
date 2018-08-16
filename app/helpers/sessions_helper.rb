module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user.
  def current_user? user
    user == current_user
  end

  def current_user
    @current_user = User.new
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
    @users.each do |u|
      if u["id"] == session[:user_id]
        @current_user = u
      end
    end
    if (user_id = session[:user_id])
      @current_user ||= @current_user
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete :user_id
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
