class Post < ApplicationRecord
  validates :content, length: { maximum: 180 }
end
