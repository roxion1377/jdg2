#!/usr/bin/env ruby
#=begin
require 'rubygems'
require 'cgi'
require 'active_record'
require 'scanf'
require 'benchmark'

PORT = 9999
USER = "ubuntu"
SRV = '10.0.3.80'
puts "./db/#{ENV['RAILS_ENV']}.sqlite3"
#print Benchmark.realtime {
  ActiveRecord::Base.establish_connection(
                                          :adapter=> 'sqlite3',
                                          :database=> "./db/production.sqlite3",
#                                          :database => "./db/#{ENV['RAILS_ENV']}.sqlite3",
                                          :pool => 5,
                                          :timeout=> 5000
                                          )
#}," sec @settings"
class Result < ActiveRecord::Base
  belongs_to :task
  has_many :details
end
class Input < ActiveRecord::Base
end
class Detail < ActiveRecord::Base
  belongs_to :result
end
class ContestTask < ActiveRecord::Base
end
class Task < ActiveRecord::Base
  has_many :inputs
end
#=end
=begin
require 'active_record'
require './config/boot.rb'
require './config/environment.rb'
require 'cgi'
require 'rubygems'
require 'scanf'
require 'benchmark'

config = YAML.load_file("config/database.yml")
ActiveRecord::Base.establish_connection(config["development"])

PORT = 9999
USER = "ubuntu"
SRV = '10.0.3.80'
=end

class Judge
  def copy_to_be(dir,file)
    `scp -P #{PORT} -c arcfour -r #{file} #{USER}@#{SRV}:#{dir}`
  end
  def copy_to_fe(dir,file)
    cmd = "scp -P #{PORT} -c arcfour -r #{USER}@#{SRV}:#{dir} #{file}"
    puts "#{cmd}"
    `#{cmd}`
    #`scp -P #{PORT} -c #{USER}@#{SRV}:#{dir} #{file}`
  end
  def cmd_be cmd
    system("ssh -p #{PORT} -c arcfour #{USER}@#{SRV} \"#{cmd}\"")
  end
  
  def initialize(id)
    @id = id
    @dir = "judge_data/#{id}"
    @dir_be = "tmp/#{id}"
    @result = Result.find(id)
  end

  def init 
    copy_to_be("~/#{@dir_be}",@dir)
    cmd_be("mkdir -p #{@dir_be}/in")
#    Dir::chdir(@dir)
  end
  
  def compile
    sc = false
    fn = "Main"
    ext = ""
    scn = ""
    case @result.lang_id
    when 1
      ext = "cpp"
      scn = "cpp"
    when 2
      ext = "c"
      scn = "c"
    else
    end
    if ext != "" && scn != ""
      sc = cmd_be("ruby sc/#{scn}.rb #{@dir_be}/")
      copy_to_fe("~/#{@dir_be}/cerror.txt","#{@dir}")
      #@result.message = CGI.escapeHTML(open("./cerror.txt").read)
      @result.message = open("#{@dir}/cerror.txt").read
    end
    return sc
  end
  
  def set_state id
    @result.state_id = id
    @result.save
  end
  
  def set_state_exit id
    set_state id
    puts "exit #{id}"
    exit 0
  end
  
  def setup_before
    @result.details.destroy_all
    data_dirs = @result.task.inputs.order(:dir_name)
    p data_dirs.size
    data_dirs.each do |data_dir|
      p data_dir.dir_name
      copy_to_be("~/#{@dir_be}/in/#{data_dir.dir_name}","./task_data/#{@result.task.id}/data/#{data_dir.dir_name}")
    end
  end

  def setup_after
    copy_to_fe("~/#{@dir_be}/outputs/","./#{@dir}/")
    copy_to_fe("~/#{@dir_be}/results/","./#{@dir}/")
    cmd_be("rm -rf #{@dir_be}")
  end

  def run
    o = (`du -k ./task_data/#{@result.task.id}/data/**/out/* | cut -f 1`)
    p o.to_s
    ol = o.to_s.split('\n').map(&:to_i).max
    case @result.lang_id
    when 1,2
      cmd_be("ruby run1.rb #{@dir_be} #{@result.task.tl} #{@result.task.ml} #{ol*2}")
    else
    end
  end
  
  def validate
    default_detail = {:state_id=>3,:time=>0,:memory=>0}
    ac = true
    state = 8
    score = 0
    c = 0
    @result.task.inputs.order(:dir_name).each do |data|
      dir_name = data.dir_name
      default_detail.store(:input,dir_name)
      inputs = Dir::glob("task_data/#{@result.task.id}/data/#{dir_name}/in/*").entries.sort
      outputs = Dir::glob("#{@dir}/outputs/#{dir_name}/*").entries.sort
      answers = Dir::glob("task_data/#{@result.task.id}/data/#{dir_name}/out/*").entries.sort
      results = Dir::glob("#{@dir}/results/#{dir_name}/*").entries.sort.map{|f|open(f)}
      tac = true
      outputs.length.times{|i|
        input = inputs[i]
        output = outputs[i]
        f = results[i]
        p input
        default_detail.store(:input,"#{dir_name}/#{File.basename(input)}")
        detail = @result.details.new(default_detail)
        case f.gets.chomp
        when 'Error'
          case f.gets.chomp
          when 'MLE'
            detail.state_id = 4
          when 'TLE'
            detail.state_id = 5
          end
          tac = false
        when 'Safe'
          code = f.gets.scanf("Exit code: %d")[0]
          mem = f.gets.scanf("%s %d")[1]
          time = (f.gets.scanf("%s %f")[1]*1000).to_i
          puts code
          if code != 0
            if code < 128
              detail.state_id = 6
            else
              if code == 137
                detail.state_id = 5
              elsif code == 153
                detail.state_id = 10
                p "d"
              else
                detail.state_id = 4
              end
            end
            tac = false
          elsif mem > @result.task.ml*1024
            detail.state_id = 4
            tac = false
          elsif time > @result.task.tl*1000
            detail.state_id = 5
            tac = false
          else
            jd = 1
            case @result.task.judge_type
            when 1
              jd = system("diff #{output} #{answers[i]} > /dev/null")
            end
            unless jd
              detail.state_id = 7
              detail.time = time
              detail.memory = mem
              tac = false
            else
              detail.state_id = 8
              detail.time = time
              detail.memory = mem
            end
          end
        end
        detail.save
        state = 10 if detail.state_id == 10
        if state != 10
          state = [state,detail.state_id].min
        end
      }
      if tac
        score += data.score
      else
        ac = false
      end
    end
    set_state state
    @result.score = score
    @result.save
  end

  def judge
    init
    set_state 1
    set_state_exit 2 unless compile
    set_state 3
    setup_before
    run
    setup_after
    validate
  end
  
end

puts "env:#{ENV['RAILS_ENV']}"
puts "result id : #{ARGV[0]}"

puts "#{Benchmark.realtime{Judge.new(ARGV[0]).judge}} sec @total"
