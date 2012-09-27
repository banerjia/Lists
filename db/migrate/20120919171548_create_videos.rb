class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, :null => false, :limit => 200
      t.text :description
      t.string :url, :null => false, :limit => 300
      t.string :unique_url, :null => false, :limit => 300
      t.string :image_url,:limit => 500
      t.integer :rating, :null => false, :default => 0
      t.string :tags, :limit => 6999
      t.boolean :active, :null => false, :default => false
      t.references :site

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE `videos` 
    CHANGE COLUMN 
    `id` `id` smallint(10) unsigned not null auto_increment
    SQL

    execute <<-SQL
    ALTER TABLE `videos` 
    CHANGE COLUMN `rating` `rating` tinyint(10) unsigned not null default 0
    SQL

    execute <<-SQL
    ALTER TABLE `videos` 
    CHANGE COLUMN `site_id` `site_id` smallint(10) unsigned not null
    SQL

    execute <<-SQL
    ALTER TABLE `videos` 
    CHANGE COLUMN `active` `active` tinyint(10) unsigned not null default 0
    SQL

    add_index :videos, :site_id
    add_index :videos, :rating
    add_index :videos, :active
  end
end
