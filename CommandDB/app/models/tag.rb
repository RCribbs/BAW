class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :command_tags
  has_many :commands, :through => :command_tags
end
