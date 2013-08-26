class Usage < ActiveRecord::Base
  attr_accessible :commandUsage, :filePath, :command_id
  belongs_to :command
  
  def self.scan_and_add(fPath)
    File.open(fPath, "r") do |aFile|
      aFile.each_line do |line|
        line.strip!
        if line.eql? '#' then next end
        if line.eql? '/*' then next end
        if line.eql? '*/' then next end
        @command = Command.find_by_name(line.split(/ /)[0])
        unless @command.nil? then
          @usage = Usage.create(:filePath => fPath, :commandUsage => line.chomp)
          @command.usages << @usage
        end
      end
    end
  end
end
