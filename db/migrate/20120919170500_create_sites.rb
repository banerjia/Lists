class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :title, :limit => 300, :null => false
      t.string :base_url, :limit => 250, :null => false
      t.integer :videos_count, :null => 0, :default => 0
      t.timestamps
    end
    execute <<-SQL
      ALTER TABLE sites 
	CHANGE COLUMN 
		id id smallint(10) unsigned not null auto_increment
    SQL
    execute <<-SQL
      ALTER TABLE `sites` 
	CHANGE COLUMN 
		videos_count videos_count  smallint(10) unsigned not null default 0
    SQL
  end
end
