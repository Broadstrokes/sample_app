class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
    has_many :following, through: :active_relationships, source: :followed
    
                                  
    attr_accessor :remember_token, :activation_token, :reset_token
    
    # ADDING VALIDATION FOR NAME
    # same as writing validates(:name, {presence: true}) 
    # same as writing validates(:name, presence: true)
    # .valid? method return if all validations pass
    # .errors.full_messages displays messages
    # user will not save to db if invalid
    # Rails validates the presence of an attribute using the .blank? method
    
    # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    # before_save callback is automatically called before the object is saved,
    # which includes both object creation and updates
    before_save :downcase_email
    
    # Same as before_save { self.email = email.downcase }
    # Same as self.email = self.email.downcase
    # (where self refers to the current user), but inside the User model the 
    # self keyword is optional on the right-hand side
    
    # before_save callback can be written using the 
    # “bang” method email.downcase! to modify the email attribute directly
    # before_save { email.downcase! }
    
    
    # in the case of the activation digest we only want the callback 
    # to fire when the user is created
    before_create :create_activation_digest
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, 
        presence: true,
        length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX },
        # uniqueness: true
        uniqueness: { case_sensitive: false }
    
    has_secure_password
    
    validates :password,
        presence: true,
        length: { minimum: 6 },
        # allowing nil allows a user to update fields 
        # other than password, otherwise password empty
        # validation is triggered
        allow_nil: true  
    
    # Returns the hash digest of a given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    
    # Returns a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    # Remembers a user in the db for use in persistent sessions
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    # Returns true if the given token matches the digest
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    # Forgets a user
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    
    # Activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    # Sends activation email
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    # Sets the password reset attributes
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(
            reset_digest: User.digest(reset_token), 
            reset_sent_at: Time.zone.now
        )
    end
    
    # Sends password reset email
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    # Returns true if a password reset has expired
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    # Defines a proto-feed
    def feed
        # the ? in the query below ensures that id is properly escaped before 
        # being included in the underlying SQL query, thereby avoiding a 
        # serious security hole called SQL injection. The id attribute here is 
        # just an integer (i.e., self.id, the unique ID of the user)
        Micropost.where("user_id = ?", id)
    end
    
    # Follows a user
    def follow(other_user)
        following << other_user
    end
    
    # Unfollows a user
    def unfollow(other_user)
        following.delete(other_user)
    end
    
    # Returns true if the current user is following the other user
    def following?(other_user)
        following.include?(other_user)
    end
    
    private
        # Converts email to all lower-case
        def downcase_email
            self.email = email.downcase
        end
        
        # Creates and assigns the activation token & digest
        def create_activation_digest
            self.activation_token  = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
