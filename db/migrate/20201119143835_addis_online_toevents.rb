class AddisOnlineToevents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_online, :boolean, null: false, default: false
  end
end
