class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  attachment :image
  has_many :events, dependent: :destroy
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  
  # class_nameによって参照するテーブルを指定
  # foreign_keyにより、relationshipsテーブルのどのカラムを参照するのかを指定
  
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  # throughを使いrelationshipsテーブルを経由して、usersテーブルを参照する
  
  # User.find.followers→自分をフォローしているユーザーの取得
  # 被フォロー関係を通じて参照→自分をフォローしている人を参照できる
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # User.find.followings→自分がフォローしている人を参照
  # 与フォロー関係を通じて参照→自分がフォローしている人を参照できる
  has_many :followings, through: :relationships, source: :followed
  
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  
  
  def follow(user_id)
    relationship = relationships.new(followed_id: user_id)
    relationship.save
  end

  def unfollow(user_id)
    relationship = Relationship.find_by(followed_id: user_id)
    relationship.destroy
  end

  def following?(user)
    followings.include?(user)
  end
  
  def matching
    followings & followers
  end
  
end
