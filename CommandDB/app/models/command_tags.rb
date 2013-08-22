class CommandTags < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :command
  belongs_to :tag
end
