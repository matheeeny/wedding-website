class RemoveUseShuttleFromRsvp < ActiveRecord::Migration
  def up
    remove_column :rsvps, :using_shuttle
  end

  def down
    add_column :rsvps, :using_shuttle, :boolean
  end
end
