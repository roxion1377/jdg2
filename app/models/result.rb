class Result < ActiveRecord::Base
  default_scope ->{ order('created_at DESC') }
  belongs_to :user
  belongs_to :task
  belongs_to :state
  has_many :details
  attr_accessor :code
  validates_presence_of :code, :task_id, :lang_id
  validates_length_of :code, minimum: 6,too_short:"短い", :allow_blank => true
  validate :exist_task
  validates_numericality_of :lang_id, :only_integer => true, :greater_than_or_equal_to=>1,:less_than_or_equal_to=>2

  scope :date_range, ->(a,b) {
    where(["created_at between ? and ?",a,b])
  }

  def get_code
    ext = {1=>"cpp",2=>"c"}
    return "" unless FileTest.exist?("judge_data/#{self.id}/Main.#{ext[self.lang_id]}")
    open("judge_data/#{self.id}/Main.#{ext[self.lang_id]}").read
  end

  def judge
    self.score = 0
    self.message = ""
    self.state_id = 9
    ret = self.save
    return ret unless ret
    path = "judge_data/#{self.id}"
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)
    FileUtils.mkdir_p("#{path}/log") unless FileTest.exist?("#{path}/log")
    ext = {1=>"cpp",2=>"c"}
    File.open("#{path}/Main.#{ext[self.lang_id]}","w"){|f|f.write(self.code)}
    contest_user = {:user=>self.user,:contest=>self.task.contest}
    ContestUser.find_or_create_by(contest_user)
    `ruby judge.rb #{self.id} > #{path}/log/log.txt &`
    #`ruby judge.rb #{self.id} > /dev/null &`
    ret
  end
  private
  def exist_task
    errors.add(:task_id, '(； ･`д･´)') unless Task.exists?(self.task_id)
#    puts ":::::::::::::::::::#{self.task}"
    true
  end
end
