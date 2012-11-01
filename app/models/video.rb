class Video < ActiveRecord::Base
  require 'uri'
  require 'net/http'

  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :title, :url, :active

  validates :title, :presence => "The entry needs a title."
  validates :url, :presence => {:message => 'Need a URL dummy'}, :format => {:with => URI.regexp, :message => 'Check the format idiot' }
  validates_uniqueness_of :unique_url, :case_sensitive => false, :message => "URL already present", :if => Proc.new { |video| video.url_changed? }

  # Callback Methods
  before_save do |video|
    return if !video.url_changed? 
    site = Site.find_or_create_by_domain(extract_domain(video[:url]), :title => extract_domain(video[:url]))
    video[:site_id]= site[:id]
  end

  before_validation do |video|
    return if !video.url_changed? || video[:url].nil?
    video[:url] = video[:url].strip.sub( /\/$/,'')
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
    success_codes = (200..207).to_a.append(226) + (300..307).to_a
    entries_to_validate = find(:all, :conditions => ["validated_at >= ? ||  validated_at IS NULL", 6.days.ago.to_date], :select => [:id, :url, :validated_at, :active] )
    entries_to_validate.each do |entry|
      valid_url = true
      begin
        url_response = Net::HTTP.get_response( URI.parse( entry[:url] ) )
        valid_url = !success_codes.index(url_response.code.to_i).nil?
      rescue 
        valid_url = false
      end
      entry[:active] = valid_url
      entry[:validated_at] = Time.now
      entry.save!(:validate => false)
    end
  end

  # Private Methods
  private 

  def extract_domain( url )
    url_pattern = /\:\/\/(.*\.)?([a-zA-Z0-9\-\_]+(\.(([a-zA-Z]{2})|gov|com|biz|net|xxx|edu|org|pro|tel|mil|int|([a-zA-Z]{4})))+)\//
    url_pattern.match(url)[2]
  end

  def extract_unique_url( url )
    url_pattern = /^http(s){0,1}\:\/\/(www\.)?/
    url.sub( url_pattern, "")
  end
end
