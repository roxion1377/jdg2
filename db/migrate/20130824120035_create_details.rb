class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.integer :memory
      t.references :result, index: true
      t.integer :state_id
      t.integer :time
      t.string :input

      t.timestamps
    end
  end
end
