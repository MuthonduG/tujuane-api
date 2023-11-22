class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :user_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :user_unprocessable_entity

    def index
        users = User.all 
        render json: users, status: :ok
    end

    def show
        user = find_user
        render json: user, status: :ok
    end

    def sign_up 
        user = User.new(user_params)
      
        user.password = user.zipcode.to_s
      
        if user.valid?  # Check if the user is valid before attempting to save
          if user.save
            render json: user, status: :created 
          else
            render json: { error: "Failed to save user" }, status: :unprocessable_entity
          end
        else
          render json: { error: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      

    def destroy
        user = find_user
        user.destroy
        head :no_content
    end

    private

    def find_user
        User.find(params[:id])
    end

    def user_params
        params.permit( :username, :email, :zipcode, :password )
    end

    def user_not_found
        render json: { error: "User not found"}, status: :ok
    end

    def user_unprocessable_entity(invalid)
        render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

end
