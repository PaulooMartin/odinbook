class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, foreign_key: 'post_id', inverse_of: 'liked_post', dependent: :destroy
  has_many :likers, through: :likes
  has_many :comments, dependent: :destroy

  validates :content, length: { maximum: 180 }, presence: true
end
