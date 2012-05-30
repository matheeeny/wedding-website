class RemoveHotels < ActiveRecord::Migration
  def up
    drop_table :hotels
    remove_column :rsvps, :hotel_id
  end

  def down
    create_table :hotels do |t|
      t.string :name
    end
    add_column :rsvps, :hotel_id, :integer
  end
end
