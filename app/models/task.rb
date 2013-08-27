class Task < ActiveRecord::Base
  default_scope ->{ order(:serial) }
  belongs_to :contest
  has_many :inputs
  has_many :results
  validates_presence_of :serial, :name,:tl,:ml,:body,:judge_type
  validates_numericality_of :tl,:ml, :only_integer=>true,:greater_than=>0, :allow_blank=>true
  validates_numericality_of :judge_type, :only_integer=>true, :allow_blank=>true
  #:greater_than_or_equal_to=>1,:less_than_or_equal_to=>1
  validates_inclusion_of :judge_type, :in => (1..1).to_a,:allow_blank=>true
  validates :serial, :uniqueness=>{:scope => :contest}
end
