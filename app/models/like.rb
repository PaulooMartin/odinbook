class Like < ApplicationRecord
  belongs_to :liker, foreign_key: 'user_id', class_name: 'User', inverse_of: 'likes'
  belongs_to :liked_post, foreign_key: 'post_id', class_name: 'Post', inverse_of: :likes

  validates_presence_of :liker, :liked_post
end
