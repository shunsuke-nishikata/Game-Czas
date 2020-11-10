class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      
      t.integer :user_id, null: false
      t.string :event_image_id
      t.string :event_name
      t.datetime :event_data
      t.datetime :starting_time
      t.datetime :ending_time
      t.string :game_location
      t.integer :place
      t.boolean :is_request, null: false, default: false
      
      
      t.timestamps null: false
    end
  end
end
