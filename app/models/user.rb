class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :zipcode, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

    has_secure_password
    has_many :posts

end
