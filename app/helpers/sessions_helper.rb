module SessionsHelper
    # logs in the given user
    def log_in(user)
        session[:user_id] = user.id
    end
    
    # return the logged in user (if any)
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
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
