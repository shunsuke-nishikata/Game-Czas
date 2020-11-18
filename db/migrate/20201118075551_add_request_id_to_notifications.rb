class AddRequestIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :request_id, :integer
  end
end
