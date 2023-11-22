class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :zipcode, presence: true, length: {is: 5 }
    

    has_secure_password

end
