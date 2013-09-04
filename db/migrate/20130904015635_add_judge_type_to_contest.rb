class AddJudgeTypeToContest < ActiveRecord::Migration
  def change
    add_column :contests, :judge_type, :integer
  end
end
