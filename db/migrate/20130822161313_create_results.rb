class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :lang_id
      t.text :message
      t.integer :state_id
      t.references :user, index: true
      t.references :task, index: true
      t.references :contest, index: true
      t.integer :score

      t.timestamps
    end
  end
end
