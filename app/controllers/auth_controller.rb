class AuthController < ApplicationController

    def log_in
        user = User.find_by(username: params[:username])
      
        if user && user.authenticate(params[:password])
          token = generate_token(user)
          render json: token, status: :ok
        else
          render json: { error: 'Invalid Username or Password' }
        end

    end
      

    private

    def generate_token(user)
        expiration = Time.now.to_i + 2.hour.to_i

        payload = {
            role: user.username,
            user_ref: user.id,
            exp: expiration
        }
        JWT.encode(payload, Rails.application.secret_key_base)
    end

end
