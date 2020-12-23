class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーションのグループ化
  with_options presence: true do
    validates :name
    validates :email
  end

  attachment :image
  has_many :events, dependent: :destroy
  has_many :event_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy

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

  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  # 自分からの通知
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  # 相手からの通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  def follow(user_id)
    relationship = relationships.new(followed_id: user_id)
    relationship.save
    # self
  end

  def unfollow(user_id)
    relationship = Relationship.find_by(followed_id: user_id)
    relationship.destroy
  end
  
  # includeは引数で指定した要素が、配列中に含まれているか判定するメソッド
  # current_userを渡してフォローしているかを確認をする
  def following?(user)
    followings.include?(user)
  end
  
  # マッチング状態のユーザーの取得、参照元
  # has_many :followers, through: :reverse_of_relationships, source: :follower
  # has_many :followings, through: :relationships, source: :followed
  def matching
    followings & followers
  end
  
  # selfはuser
  # search_wordはフォームに入力された文字列
  def self.search_for(search_word)
    if search_word
      # SQLでLIKE句を使用すると、対象の列(カラム)に対して文字列検索を行うことができる
      User.where('name LIKE ?', '%' + search_word + '%')
    else
      @search_users = User.where.not(id: current_user.id)
      @search_users = User.page(params[:page]).per(8)
    end
  end

  def self.guest
    # 条件を指定して初めの1件を取得、1件もなければ作成、emailがguest@example.comのユーザー
    # ついでに名前とパスワードも作成
    find_or_create_by!(email: 'guest@example.com') do |user|
      # パスワードをランダム生成
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  # フォロー用の通知機能
  def create_notification_follow(current_user)
    # SQLインジェクションの文字列での指定、.blank?はnilまたは空のオブジェクトを判定する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save
    end
  end
end
