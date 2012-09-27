class Video < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :title, :url, :active

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

  # Instance Methods
  def destroy
    video_to_archive = VideosArchive.new()
    video_to_archive[:id] = self[:id]
    video_to_archive[:title] = self[:title]
    video_to_archive[:description] = self[:description]
    video_to_archive[:image_url] = self[:image_url]
    video_to_archive[:rating] = self[:rating]
    video_to_archive[:tags] = self[:tags]
    video_to_archive[:url] = self[:url]
    video_to_archive[:unique_url] = self[:unique_url]
    video_to_archive[:site_id] = self[:site_id]
    video_to_archive[:created_at] = self[:created_at]    
    video_to_archive.save
    super    
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
