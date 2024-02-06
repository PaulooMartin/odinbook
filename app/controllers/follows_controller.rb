class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :follow_already_exists?, only: [:create]
  before_action :tries_follow_self?, only: [:create]

  def create
    followee = User.find(params[:user])
    follow = current_user.follows_outbound.build(followee_id: followee.id)

    if follow.save
      redirect_to root_url, notice: "Successfully followed #{followee.full_name}"
    else
      redirect_to root_url, alert: "An error occurred when trying to follow #{followee.full_name}"
    end
  end

  def update; end

  def destroy; end

  private

  def follow_already_exists?
    followee = User.find(params[:user])

    return unless Follow.find_by(follower_id: current_user.id, followee_id: followee.id)

    redirect_to root_url, alert: "You already followed #{followee.full_name}"
  end

  def tries_follow_self?
    followee = User.find(params[:user])

    return unless current_user == followee

    redirect_to root_url, alert: 'You cannot follow yourself!'
  end
end
