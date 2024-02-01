class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :post_exists?
  before_action :comment_owner?, only: %i[edit update destroy]

  def new
    @post = Post.find(params[:post_id])
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.commentor = current_user

    if @comment.save
      redirect_to @post, notice: 'Comment added successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to @post, notice: 'Comment updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def post_exists?
    message = 'You are making a comment on a post that does not exist'
    redirect_to(root_url, alert: message) unless Post.find_by(id: params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def comment_owner?
    comment = Comment.find(params[:id])
    redirect_to(root_url, alert: 'You are not the owner of that comment') unless current_user == comment.commentor
  end
end
