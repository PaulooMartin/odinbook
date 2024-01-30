class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :like_already_exists?, only: [:create]

  def create
    post = Post.find(params[:post])
    like = Like.build(post_id: post.id, user_id: current_user.id)

    if like.save
      redirect_to root_url, notice: 'Post liked successfully'
    else
      redirect_to root_url, alert: 'Post like error'
    end
  end

  def destroy
    post = Post.find(params[:post])
    like = Like.find_by(post_id: post.id, user_id: current_user.id)
    like.destroy

    redirect_to root_url, notice: 'Successfully unliked a post'
  end

  private

  def like_already_exists?
    post = Post.find(params[:post])

    if Like.find_by(post_id: post.id, user_id: current_user.id)
      redirect_to root_url, alert: 'You already liked this post!'
    end
  end
end
