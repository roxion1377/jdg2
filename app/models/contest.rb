class Contest < ActiveRecord::Base
  validates_presence_of :name,:begin,:end, :judge_type
  validates_datetime :begin,:end
  validates_datetime :end, :after => :begin
  validates :judge_type, inclusion: {in:1..2}
  has_many :tasks
  has_many :contest_users
  has_many :users, :through => :contest_users
end
