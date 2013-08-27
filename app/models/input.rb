class Input < ActiveRecord::Base
  belongs_to :task
  validates_presence_of :dir_name,:score
  validates_length_of :dir_name, :minimum=>1, :maximum=>30, :allow_blank => true
  validates_format_of :dir_name, :with => /\A[0-9a-z_]*\Z/, :message => "小文字アルファベットと数字と_だけ"
  validates_numericality_of :score, :only_integer=>true,:greater_than=>0
  validates :dir_name,:uniqueness => {:scope => :task}

  def dir_name=(v)
    write_attribute :dir_name,(v ? v.downcase : nil)
  end
  def save_file(params)
    path = "task_data/#{self.task.id}/data/#{self.dir_name}"
    setup_dir path
#    logger.info( "log::::::::::::::#{params[:input]}" )
    inputs  = (params[:input]||[]).sort{|a,b| a.original_filename<=>b.original_filename}
    outputs = (params[:output]||[]).sort{|a,b| a.original_filename<=>b.original_filename}
    inputs.each{|p|File.open("#{path}/in/#{p.original_filename}","w"){|f|f.write(p.read)}}
    outputs.each{|p|File.open("#{path}/out/#{p.original_filename}","w"){|f|f.write(p.read)}}
    true
  end
  def destroy
    path = "task_data/#{self.task.id}/data/#{self.dir_name}"
    Dir::glob("#{path}/**/*").select{|f|File.file?(f)}.each{|f|
      File.delete(f)
    }
    Dir::rmdir("#{path}/in") if FileTest.exist?("#{path}/in")
    Dir::rmdir("#{path}/out") if FileTest.exist?("#{path}/in")
    Dir::rmdir("#{path}") if FileTest.exist?("#{path}/in")
    super
  end
  private
  def setup_dir(path)
    FileUtils.mkdir_p(path+"/in")  unless FileTest.exist?(path+"/in")
    FileUtils.mkdir_p(path+"/out") unless FileTest.exist?(path+"/out")
  end
end
