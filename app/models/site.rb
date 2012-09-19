class Site < ActiveRecord::Base
  has_many :videos
  attr_accessible :base_url, :title
end
