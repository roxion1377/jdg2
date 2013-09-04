class CreateOmakes < ActiveRecord::Migration
  def change
    create_table :omakes do |t|

      t.timestamps
    end
  end
end
