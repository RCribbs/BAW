class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.text :path
      t.text :content

      t.timestamps
    end
  end
end
