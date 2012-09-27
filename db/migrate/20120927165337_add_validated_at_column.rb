class AddValidatedAtColumn < ActiveRecord::Migration
  def up
	add_column :videos, :validated_at, :datetime, :after => :unique_url
	add_column :videos_archives, :validated_at, :datetime, :after => :unique_url

	add_index :videos, :validated_at
  end

  def down
	remove_column :videos, :validated_at
	remove_column :videos_archives, :validated_at
  end
end
