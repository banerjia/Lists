class VideosArchive < ActiveRecord::Base  
  belongs_to :site
  attr_accessible :description, :image_url, :rating, :tags, :title, :url 

  # Instance Methods
  def destroy
    video_to_undelete = Video.new()
    self.attributes.each do |key, value|
      video_to_undelete[key] = value unless key == "updated_at"
    end
    video_to_undelete[:active] = true
    video_to_undelete.save	
    super
  end

  # Class Methods
  def self.purge_old_entries
    delete_all( :conditions => ["updated_at <= ?", 1.day.ago.to_date] )
  end
end