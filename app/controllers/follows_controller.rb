class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :init_followee, only: [:create]
  before_action :followee_exists?, only: [:create]
  before_action :tries_follow_again?, only: [:create]
  before_action :tries_follow_self?, only: [:create]
  before_action :follow_exists?, except: [:create]
  before_action :current_user_is_followee?, only: [:update]
  before_action :current_user_is_participant?, only: [:destroy]

  def create
    follow = current_user.follows_outbound.build(followee_id: @followee.id)

    if follow.save
      redirect_to root_url, notice: "Successfully followed #{@followee.full_name}"
    else
      redirect_to root_url, alert: "An error occurred when trying to follow #{@followee.full_name}"
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

  def init_followee
    @followee = User.find_by(id: params[:user])
  end

  def followee_exists?
    redirect_to(root_url, alert: "The person you're trying to follow does not exist!") unless @followee
  end

  def tries_follow_again?
    follow = Follow.find_by(follower_id: current_user.id, followee_id: @followee.id)
    redirect_to(root_url, alert: "You already followed #{@followee.full_name}") if follow
  end

  def tries_follow_self?
    redirect_to(root_url, alert: 'You cannot follow yourself!') if current_user == @followee
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
