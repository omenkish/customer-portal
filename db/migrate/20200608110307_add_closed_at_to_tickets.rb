class AddClosedAtToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :closed_at, :datetime
  end
end
