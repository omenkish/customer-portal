class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
