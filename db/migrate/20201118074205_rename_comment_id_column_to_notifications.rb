class RenameCommentIdColumnToNotifications < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :comment_id, :event_comment_id
    rename_column :events, :event_data, :event_date
  end
end
