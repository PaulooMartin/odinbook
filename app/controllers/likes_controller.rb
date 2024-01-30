class LikesController < ApplicationController
  def create
    post = Post.find(params[:post])
    like = Like.build(post_id: post.id, user_id: current_user.id)

    if like.save
      redirect_to root_path, notice: 'Post liked successfully'
    else
      redirect_to root_path, alert: 'Post like error'
    end
  end
end
