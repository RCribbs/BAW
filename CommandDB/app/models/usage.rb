class Usage < ActiveRecord::Base
  attr_accessible :commandUsage, :filePath, :command_id
  belongs_to :command
end
