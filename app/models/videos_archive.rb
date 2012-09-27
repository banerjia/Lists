class VideosArchive < ActiveRecord::Base  
  belongs_to :site
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url, :unique_url  
end