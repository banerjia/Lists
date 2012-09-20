class Video < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url, :active
  
  
end
