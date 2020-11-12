class Event < ApplicationRecord
  
  belongs_to :user
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  
  # 引数で渡されたユーザーIDがlikesテーブル内に存在するかどうか調べるメソッド
  # いいねの重複を防ぐ
  # 引数はuserとする
  def likes_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  def start_time
    self.event_data
  end
  
end
