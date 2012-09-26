class Video < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url, :active
  validates :url, :presence => {:message => "URL is required dummy"}, \
                  :uniqueness => {:case_sensitive => false, :message => "URL already present"}

  before_save do |video|
    return if video[:url].blank?
    site = Site.find_or_create_by_domain(extract_domain(video[:url]), :title => extract_domain(video[:url]))
    video[:site_id]= site[:id]
  end

  private

  def extract_domain( url )
    url_pattern = /\:\/\/.*?\.([a-zA-Z0-9\-\_]+(\.(([a-zA-Z]{2})|gov|com|biz|net|xxx|edu|org|pro|tel|mil|int|([a-zA-Z]{4})))+)\//
    url_pattern.match(url)[1]
  end

  def cleanse_video_url_for_comparison( url )
    url_pattern = /^http(s){0,1}\:\/\/www\./
    url.sub( url_pattern, "")
  end
end
