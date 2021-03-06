class CommentsController < ApplicationController
  before_action :require_login
  before_action :load_post

    def show
      @comment = Comment.find(params[:id])
    end

    def create

      @comment = Comment.new(comment_params)

      respond_to do |format|
        if @comment.save
          @comment.create_activity :create, owner: current_user, recipient: @comment.post.user
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.js   {}
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end

    end

    def destroy
      @comment = Review.find(params[:id])
      @comment.create_activity :destroy, owner: current_user, recipient: @comment.post.user
      @comment.destroy

    end

    private
    def comment_params
      params.require(:comment).permit(:comment, :post_id, :user_id)
    end

    def load_post
      @post = Post.find(params[:post_id])
    end


end
