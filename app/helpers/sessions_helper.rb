module SessionsHelper
    # Logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # Remembers a user in a persistent session
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
    
    # Returns true if the given user is the current user
    def current_user?(user)
        user == current_user
    end
    
    # Return the logged in user (if any)
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
    
    # Checks if a user is logged in; returns true if user is logged in
    def logged_in?
        !current_user.nil?
    end
    
    # Logs out a current user
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
    
    # Forget a persistent session
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
end
