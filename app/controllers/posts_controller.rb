class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :post_owner?, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post, notice: 'Successfully edited this post'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_url, notice: 'Post has been deleted'
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def post_owner?
    post = Post.find(params[:id])
    redirect_to(root_url, alert: 'Unauthorized request') unless current_user == post.user
  end
end
