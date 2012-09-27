class Video < ActiveRecord::Base
  require 'uri'
  require 'net/http'

  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :title, :url, :active

  validates :url, :presence => {:message => 'Need a URL dummy'}, :format => {:with => URI.regexp, :message => 'Check the format idiot' }
  validates_format_of :url, :with => URI.regexp
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

  # Instance Methods
  def destroy
    video_to_archive = VideosArchive.new()
	self.attributes.each do |key,value|
		video_to_archive[key] = value unless key == "updated_at" || key == "active"
	end
    video_to_archive.save
    super    
  end
  
  # Class Methods
  def self.validate_urls
	success_codes = (200..2007).to_a.append(226) + (300..307).to_a
	entries_to_validate = find(:all, :conditions => ["validated_at <= ? ||  validated_at = NULL", 7.days.ago], :select => [:id, :url, :validated_at, :active] )
	entries_to_validate.each do |entry|
		entry[:validated_at] = Time.now
		url_to_validate = URI.parse( entry[:url] )
		begin
			url_response = Net::HTTP.get_response( url_to_validate )
		rescue
			entry[:active] = false
		end
		entry.save
	end
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
