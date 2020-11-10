class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  attachment :image
  has_many :events, dependent: :destroy
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
end
