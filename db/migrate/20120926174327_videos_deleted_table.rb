class VideosDeletedTable < ActiveRecord::Migration
  def up
    create_table :videos_archives do |t|
      t.string :title, :null => false, :limit => 200
      t.text :description
      t.string :url, :null => false, :limit => 300
      t.string :unique_url, :null => false, :limit => 300
      t.string :image_url,:limit => 500
      t.integer :rating, :null => false, :default => 0
      t.string :tags, :limit => 6999
      t.references :site

      t.timestamps
    end

    execute <<-SQL
    ALTER TABLE `videos_archives` 
    CHANGE COLUMN 
    `id` `id` smallint(10) unsigned not null
    SQL

    execute <<-SQL
    ALTER TABLE `videos_archives` 
    CHANGE COLUMN `rating` `rating` tinyint(10) unsigned default 0 not null
    SQL

    execute <<-SQL
    ALTER TABLE `videos_archives` 
    CHANGE COLUMN `site_id` `site_id` smallint(10) unsigned not null
    SQL
  end

  def down
    drop_table :videos_archives
  end
end
