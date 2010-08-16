module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures. (and now by User, ID or login)
  def login_as(user)
#    @request.session[:user_id] = user ? users(user).id : nil
#    @request.session[:user_id] = user ? ( (user.is_a?(Symbol)) ? users(user).id : User.find(user).id ) : nil
    @request.session[:user_id] = case #user 
			when user.nil?           then nil
			when user.is_a?(User)    then user.id
			when user.is_a?(Symbol)  then users(user).id
			when user.is_a?(Integer) then User.find(user).id
			when user.is_a?(String)  
#				"123".to_i.to_s   = "123"
#				"aaron".to_i.to_s = "0"
				if user.to_i.to_s == user
					User.find(user).id
				else
					User.find_by_login(user).id
				end
#			else User.find(user).id
			else nil
		end
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
