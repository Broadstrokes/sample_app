class User < ApplicationRecord
    # ADDING VALIDATION FOR NAME
    # same as writing validates(:name, {presence: true}) 
    # same as writing validates(:name, presence: true)
    # .valid? method return if all validations pass
    # .errors.full_messages displays messages
    # user will not save to db if invalid
    # Rails validates the presence of an attribute using the .blank? method
    
    # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    before_save { self.email = email.downcase }
    # Same as self.email = self.email.downcase
    # (where self refers to the current user), but inside the User model the 
    # self keyword is optional on the right-hand side
    
    # before_save callback can be written using the 
    # “bang” method email.downcase! to modify the email attribute directly
    # before_save { email.downcase! }
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, 
        presence: true,
        length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX },
        # uniqueness: true
        uniqueness: { case_sensitive: false }
    validates :password,
        presence: true,
        length: { minimum: 6 }
    
    has_secure_password
    
    # Returns the hash digest of a given string
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ?
            BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
