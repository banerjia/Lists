class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags, :id => false do |t|
      t.string :tag, :null => false, :default => 'porn'

      t.timestamps
    end
    
    add_index :tags, :tag, :unique => true
  end
end
