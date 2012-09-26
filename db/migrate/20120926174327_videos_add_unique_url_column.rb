class VideosAddUniqueUrlColumn < ActiveRecord::Migration
  def up
	add_column :videos, :unique_url, :string, :limit => 255, :after => :url, :null => false
	add_column :videos, :deleted_on, :datetime, :after => :active
	
	add_index :videos, :unique_url
	add_index :videos, :deleted_on
  end

  def down
	remove_column :videos, [:unique_url, :deleted_on]
  end
end
