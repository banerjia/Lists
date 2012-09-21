class Video < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  attr_accessible :description, :image_url, :rating, :tags, :tags, :title, :url, :active
  
  before_save do |video|
    site = Site.find_or_create_by_domain(extract_domain(video[:url]), :title => extract_domain(video[:url]))
    video[:site_id]= site[:id]
  end
  
  private
  
  def extract_domain( url )
    /\:\/\/.*?\.([a-zA-Z0-9\-\_]+(\.(([a-zA-Z]{2})|gov|com|biz|net|xxx|edu|org|pro|tel|mil|int|([a-zA-Z]{4})))+)\//.match(url)[1]
  end
end
