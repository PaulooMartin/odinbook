class Comment < ApplicationRecord
  belongs_to :commentor, class_name: 'User', foreign_key: 'user_id', inverse_of: 'comments'
  belongs_to :post

  validates :content, presence: true, length: { maximum: 180 }
end
