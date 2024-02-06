class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_follow
  before_action :other_user_exists?
  before_action :follow_already_exists?, only: [:create]
  before_action :tries_follow_self?, only: [:create]

  def create
    # other_user refers to person being followed
    follow = current_user.follows_outbound.build(followee_id: @other_user.id)

    if follow.save
      redirect_to root_url, notice: "Successfully followed #{@other_user.full_name}"
    else
      redirect_to root_url, alert: "An error occurred when trying to follow #{@other_user.full_name}"
    end
  end

  def update
    # other_user refers to follower
    follow = current_user.follows_inbound.pending.find_by(follower_id: @other_user.id)

    if follow.update(pending: false)
      redirect_to root_url, notice: "You have accepted #{@other_user.full_name}'s follow request"
    else
      redirect_to root_url, alert: "An error occured when trying to accept #{@other_user.full_name}'s follow request"
    end
  end

  def destroy; end

  private

  def init_follow
    @other_user = User.find_by(id: params[:user])
  end

  def other_user_exists?
    redirect_to(root_url, alert: 'Other user does not exist!') unless @other_user
  end

  def follow_already_exists?
    # other_user refers to person being followed
    follow = Follow.find_by(follower_id: current_user.id, followee_id: @other_user.id)
    redirect_to(root_url, alert: "You already followed #{@other_user.full_name}") if follow
  end

  def tries_follow_self?
    # other_user refers to person being followed
    redirect_to(root_url, alert: 'You cannot follow yourself!') if current_user == @other_user
  end
end
