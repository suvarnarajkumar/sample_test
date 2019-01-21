class User < ApplicationRecord
  has_many :users, class_name: 'User'
  belongs_to :parent_user, class_name: 'User', :foreign_key => 'user_id', optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_one_attached :picture
  has_many :posts, dependent: :destroy
end
