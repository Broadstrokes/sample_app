module SessionsHelper
    # logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # remembers a user in a persistent session
    def remember(user)
        user.remember
        # set cookies
        # cookies[:user_id] = { value: user.id, expires: 20.years.from_now.utc }
        # we can use .permanent to set 20 years from now
        # we can use .signed to encrypt the cookie so plain text user id is not exposed
        cookies.permanent.signed[:user_id] = user.id
        # put remember_token on the cookie also
        cookies.permanent[:remember_token] = user.remember_token
    end
    
    # return the logged in user (if any)
    def current_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    
    # checks if a user is logged in
    # returns true if user is logged in
    def logged_in?
        !current_user.nil?
    end
    
    # logs out a current user
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
end
