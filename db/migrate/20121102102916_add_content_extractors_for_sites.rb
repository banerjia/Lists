class AddContentExtractorsForSites < ActiveRecord::Migration
  def up
    add_column :sites, :title_pattern, :string, :limit => 1000, :after => :domain
    add_column :sites, :description_pattern, :string, :limit => 1000, :after => :title_pattern
    add_column :sites, :image_pattern, :string, :limit => 1000, :after => :description_pattern
  end

  def down
    drop_column :sites, [:title_pattern, :description_pattern, :image_pattern]
  end
end
