class Contest < ActiveRecord::Base
  validates_presence_of :name,:begin,:end
  validates_datetime :begin,:end
  validates_datetime :end, :after => :begin
  has_many :tasks
  has_many :contest_users
  has_many :users, :through => :contest_users
end
