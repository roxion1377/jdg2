class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.references :task, index: true
      t.string :dir_name
      t.integer :score

      t.timestamps
    end
  end
end
