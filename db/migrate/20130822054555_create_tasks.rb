class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :tl
      t.integer :ml
      t.text :body
      t.string :serial
      t.integer :judge_type
      t.references :contest, index: true

      t.timestamps
    end
    add_index(:tasks,[:serial,:contest_id],:unique=>true)
  end
end
