class AddCodeSizeToResult < ActiveRecord::Migration
  def change
    add_column :results, :code_size, :integer
  end
end
