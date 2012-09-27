class VideosArchive < ActiveRecord::Base  
  belongs_to :site
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url 
  
  # Instance Methods
  def undelete
    video_to_undelete = VideosArchive.new()
	self.each do |key, value|
		video_to_undelete[key] = value unless key == "updated_at"
	end
	video_to_undelete[:active] = true
    video_to_undelete.save	
	self.destroy
  end
  
  # Class Methods
  def self.purge_old_entries
	delete_all( :conditions => ["updated_at <= ?", 7.days.ago] )
  end
end