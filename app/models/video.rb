class Video < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url, :active
  
  validates_presence_of :url, :message => "URL is required dummy"
  validates_uniqueness_of :unique_url, :case_sensitive => false, :message => "URL already present"
  
# Callback Methods
  before_save do |video|
    return if video[:url].blank?
    site = Site.find_or_create_by_domain(extract_domain(video[:url]), :title => extract_domain(video[:url]))
    video[:site_id]= site[:id]
  end
  
  before_validation do |video|
	video[:unique_url] = extract_unique_url( video[:url] )
  end

# Class Methods
  def self.mark_for_deletion( video_id )
	update_all( { \
					:deleted_on => Time.now, \
					:active => :false \
				}, \
				{ \
					:id => video_id \
				})
  end 
  
# Private Methods
  private

  def extract_domain( url )
    url_pattern = /\:\/\/.*?\.([a-zA-Z0-9\-\_]+(\.(([a-zA-Z]{2})|gov|com|biz|net|xxx|edu|org|pro|tel|mil|int|([a-zA-Z]{4})))+)\//
	url_pattern.match(url)[1]
  end

  def extract_unique_url( url )
    url_pattern = /^http(s){0,1}\:\/\/www\./
    url.sub( url_pattern, "")
  end
end
