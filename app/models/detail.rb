class Detail < ActiveRecord::Base
  belongs_to :result
  belongs_to :state
end
