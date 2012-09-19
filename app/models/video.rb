class Video < ActiveRecord::Base
  default_scope :conditions => {:active => true }

  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url
end
