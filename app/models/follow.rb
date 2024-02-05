class Follow < ApplicationRecord
  scope :pending, -> { where pending: true }
  scope :accepted, -> { where pending: false }

  # follower refers to the person following
  # followee refers to the person being followed by the follower
  belongs_to :follower, foreign_key: 'follower_id', class_name: 'User', inverse_of: 'follow_outbound'
  belongs_to :followee, foreign_key: 'followee_id', class_name: 'User', inverse_of: 'follow_inbound'
end
