class Post < ApplicationRecord
  belongs_to :user
  has_many :likes
  
  validates :content, length: { maximum: 180 }, presence: true
end
