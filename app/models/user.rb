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
    
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, 
        presence: true,
        length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX }
end
