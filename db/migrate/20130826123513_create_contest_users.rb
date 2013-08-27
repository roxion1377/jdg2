class CreateContestUsers < ActiveRecord::Migration
  def change
    create_table :contest_users do |t|
      t.references :user, index: true
      t.references :contest, index: true

      t.timestamps
    end
  end
end
