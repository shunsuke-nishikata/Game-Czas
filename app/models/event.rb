class Event < ApplicationRecord
  
  belongs_to :user
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  
  # 引数で渡されたユーザーIDがlikesテーブル内に存在するかどうか調べるメソッド
  # いいねの重複を防ぐ
  # 引数はuserとする
  def likes_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  def requests_by?(user)
    requests.where(user_id: user.id).exists?
  end
  
  # カレンダー使用のためのメソッド
  def start_time
    self.event_date
  end
  
  # 検索フォームのメソッド
  def self.search_for(search_word)
    if search_word
      Event.where('event_name LIKE ?', '%'+search_word+'%')
      # Event.where('event_name ?', search_word + '%')
      # Event.where('event_name ?', '%' + search_word)
    else
      @search_events = Event.page(params[:page]).per(8)
    end
  end
  
  # いいね用の通知メソッド
  def create_notification_like(current_user)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: user_id,
      action: 'like'
    )
    # 自分の投稿に対するいいねの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save
  end
  
  # リクエストの通知機能
  def create_notification_request(current_user)
    notification = current_user.active_notifications.new(
      event_id: id,
      visited_id: user_id,
      action: 'request'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save
  end
  
  # コメント用の通知機能
  def create_notification_comment(current_user, event_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員の通知を送る
    temp_ids = EventComment.select(:user_id).where(event_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, event_comment_id, temp_id['user_id'])
    end  
    save_notification_comment(current_user,event_comment_id, user_id) if temp_ids.blank?
  end
  
  def save_notification_comment(current_user, event_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      event_id: id,
      event_comment_id: event_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save
  end
  
  
end
