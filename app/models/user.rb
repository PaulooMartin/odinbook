class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, foreign_key: 'user_id', inverse_of: 'liker', dependent: :destroy
  has_many :liked_posts, through: :likes
  has_many :comments, foreign_key: 'user_id', inverse_of: 'commentor', dependent: :destroy
  # im unsure about the naming for :follow being follow_[direction]
  has_many :follow_outbound, class_name: 'Follow', foreign_key: 'follower_id', inverse_of: 'follower'
  has_many :follow_inbound, class_name: 'Follow', foreign_key: 'followee_id', inverse_of: 'followee'

  validates_presence_of :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end
