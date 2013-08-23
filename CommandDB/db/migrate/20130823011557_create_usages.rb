class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :filePath
      t.string :commandUsage

      t.timestamps
    end
  end
end
