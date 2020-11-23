class Notification < ApplicationRecord
  # 作成日時の降順で常に新しい通知からデータを取得する記述
  default_scope -> { order(created_at: :desc) }

  # optional: trueはnilを許可するオプション
  # 本来belongs_toはnilが許可されない

  belongs_to :event, optional: true
  belongs_to :event_comment, optional: true
  belongs_to :room, optional: true
  belongs_to :message, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end