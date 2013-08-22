class CreateCommandTags < ActiveRecord::Migration
  def change
    create_table :command_tags, :id => false do |t|
      t.integer :command_id
      t.integer :tag_id
    end
  end
end
