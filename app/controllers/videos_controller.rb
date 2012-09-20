class VideosController < ApplicationController
  def index
	@recently_added = Video.find(:all, :conditions => ["active = ? and created_at <= ?", 1, 7.days.ago], :limit => [0,5], :order => "created_at desc")
	@top_videos = Video.find(:all, :conditions => ["active = ? and rating >= ? ", 1, 5 ], :limit => [0,5], :order => "rating desc")
  end
  
  def new
	@new_video = Video.new
  end
end
