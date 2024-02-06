class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_follow, only: [:create]
  before_action :other_user_exists?, only: [:create]
  before_action :tries_follow_again?, only: [:create]
  before_action :tries_follow_self?, only: [:create]
  before_action :follow_exists?, except: [:create]
  before_action :current_user_is_followee?, only: [:update]
  before_action :current_user_is_participant?, only: [:destroy]

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
    follow = Follow.find(params[:id])

    if follow.update(pending: false)
      redirect_to root_url, notice: "You have accepted #{follow.follower.full_name}'s follow request"
    else
      redirect_to root_url, alert: "An error occured when trying to accept #{follow.follower.full_name}'s follow request"
    end
  end

  def destroy
    follow = Follow.find(params[:id])
    follow.destroy

    redirect_to root_url, notice: 'Unfollow successful'
  end

  private

  def init_follow
    @other_user = User.find_by(id: params[:user])
  end

  def other_user_exists?
    redirect_to(root_url, alert: 'Other user does not exist!') unless @other_user
  end

  def tries_follow_again?
    # other_user refers to person being followed
    follow = Follow.find_by(follower_id: current_user.id, followee_id: @other_user.id)
    redirect_to(root_url, alert: "You already followed #{@other_user.full_name}") if follow
  end

  def tries_follow_self?
    # other_user refers to person being followed
    redirect_to(root_url, alert: 'You cannot follow yourself!') if current_user == @other_user
  end

  def follow_exists?
    follow = Follow.find_by(id: params[:id])
    redirect_to(root_url, alert: 'Follow does not exists!') unless follow
  end

  def current_user_is_followee?
    follow = Follow.find(params[:id])
    redirect_to(root_url, alert: 'You are not the one being followed') unless current_user == follow.followee
  end

  def current_user_is_participant?
    follow = Follow.find(params[:id])
    redirect_to(root_url, alert: 'You are not a participant of this follow') unless follow.participant?(current_user)
  end
end
