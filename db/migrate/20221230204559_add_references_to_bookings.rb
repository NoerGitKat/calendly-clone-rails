class AddReferencesToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :meeting_id, :integer
  end
end
