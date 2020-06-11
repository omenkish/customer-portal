class AddAssignedToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :assigned, :boolean, default: false
  end
end
