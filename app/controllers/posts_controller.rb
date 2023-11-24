class PostsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :post_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :post_unprocessable_entity
  
    def index
        if can_view_more_posts?
          # Limit the number of posts to fetch based on the post_view_limit
          posts = Post.order(created_at: :desc).limit(20)
          render json: posts, status: :ok
          update_viewed_post_count
        else
          render json: { error: "You have reached your post viewing limit for the day." }, status: :forbidden
        end
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
      Post.find(params[:id])
    end
  
    def post_not_found
      render json: { error: "Post not found" }, status: :not_found
    end
  
    def post_unprocessable_entity(invalid)
      render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
  
    def can_view_more_posts?
        return true unless @current_user.posts_viewed_count
      
        # Define the limit and the time frame (24 hours)
        post_view_limit = 20
        time_frame = 24.hours.ago.in_time_zone("UTC")  # Adjust the time zone accordingly
      
        # Check if the user has viewed fewer posts than the limit in the specified time frame
        posts_viewed_in_time_frame = @current_user.posts.where("created_at > ?", time_frame).count
      
        # Update the limit here, limiting the number of posts to be displayed
        posts_viewed_in_time_frame < post_view_limit
    end
      
  
    def update_viewed_post_count
      # Increment the count of viewed posts
      @current_user.increment!(:posts_viewed_count)
    end
  end