class Message < ApplicationRecord
  validates :message, presence: true

  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy

  # def create_notification_message(current_user, message_id, room_id, visited_id)
  #   notification = current_user.active_notifications.new(
  #     message_id: id,
  #     visited_id: visited_id,
  #     room_id: room_id,
  #     action: 'message'
  #     )
  #   notification.save
  # end
end
