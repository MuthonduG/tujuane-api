class PostsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :post_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :post_unprocessable_entity

    def index
        post = Post.all
        render json: post, status: :ok
    end

    def show
        post = find_post
        render json: post, status: :ok
    end

    def create_post
        post = @current_user.posts.build(post_params)
    
        if post.save
          render json: post, status: :created
        else
          render json: { error: post.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def post_params
        params.permit(:title, :content, :image_url)
    end

    def find_post
        Post.find(params[:title])
    end

    def post_not_found
        render json: { error: "User not found"}, status: :ok
    end

    def post_unprocessable_entity(invalid)
        render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end


end
