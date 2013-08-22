class Command < ActiveRecord::Base
  attr_accessible :content, :name, :path
  has_many :command_tags
  has_many :tags, :through => :command_tags
end
