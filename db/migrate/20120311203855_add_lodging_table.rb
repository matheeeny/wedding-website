class AddLodgingTable < ActiveRecord::Migration
  def up
    create_table :hotels do |t|
      t.string :name
    end
  end

  def down
  end
end
