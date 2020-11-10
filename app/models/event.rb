class Event < ApplicationRecord
  
  belongs_to :user
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  
  # 引数で渡されたユーザーIDがlikesテーブル内に存在するかどうか調べるメソッド
  # いいねの重複を防ぐ
  def likes_by?(user_id)
    likes.where(user_id: user.id).exists?
  end
end
