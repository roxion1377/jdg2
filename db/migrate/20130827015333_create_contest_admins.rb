class CreateContestAdmins < ActiveRecord::Migration
  def change
    create_table :contest_admins do |t|
      t.references :user, index: true
      t.references :contest, index: true

      t.timestamps
    end
  end
end
