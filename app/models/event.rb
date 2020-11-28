class Event < ApplicationRecord
  belongs_to :user
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :notifications, dependent: :destroy

  with_options presence: true do
    validates :event_name
    validates :event_date
    validates :starting_time
    validates :ending_time
    validates :game_location
  end

  # 引数で渡されたユーザーIDがlikesテーブル内に存在するかどうか調べるメソッド
  # いいねの重複を防ぐ
  # 引数はuserとする
  def likes_by?(user)
    likes.where(user_id: user.id).exists?
  end
  
  # exists?は条件にマッチするレコードがあればtrueを返し、レコードがなければfalseを返します。
  # 自分がリクエストしているのかの確認
  def requests_by?(user)
    requests.where(user_id: user.id).exists?
  end

  # カレンダー使用のためのメソッド
  # start_timeで命名しないと処理が適応されない
  def start_time
    event_date
  end
  
  # selfはevent
  # 検索フォームのメソッド
  # search_wordはフォームに入力された文字列
  def self.search_for(search_word)
    if search_word
      # SQLでLIKE句を使用すると、対象の列(カラム)に対して文字列検索を行うことができる
      Event.where('event_name LIKE ?', '%' + search_word + '%')
      # Event.where('event_name ?', search_word + '%')
      # Event.where('event_name ?', '%' + search_word)
    else
      @search_events = Event.page(params[:page]).per(8)
    end
  end
  
  
  # ---------------------------
  # ------ 通知機能 -----------
  # ----------------------------
  # 下記user.rb記載
  #自分からの通知
  # has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  # has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  
  
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
  # 投稿にコメントしているユーザーIDのリストを取得する=> EventComment.select(:user_id).where(event_id: id)
  # 自分のコメントは除外する=> where.not(user_id: current_user.id)
  # 重複した場合は削除する=> distinct
  def create_notification_comment(current_user, event_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員の通知を送る
    # distinctメソッドは重複レコードを1つにまとめるためのメソッドselectメソッドとセットで使用しないと重複する(取得した全員表示)
    temp_ids = EventComment.select(:user_id).where(event_id: id).where.not(user_id: current_user.id).distinct
    
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, event_comment_id, temp_id['user_id'])
    end
    # .blank?はnilまたは空のオブジェクトを判定する
    save_notification_comment(current_user, event_comment_id, user_id) if temp_ids.blank?
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
