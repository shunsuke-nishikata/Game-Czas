class RenamePlaceColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :place, :price
  end
end
