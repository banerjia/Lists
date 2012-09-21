class VideosController < ApplicationController
  def index
	  @recently_added = Video.find(:all, :conditions => ["active = ? and created_at >= ?", 1, 7.days.ago], :limit => "0,5", :order => "created_at desc")
	  @top_videos = Video.find(:all, :conditions => ["active = ? and rating >= ? ", 1, 5 ], :limit => "0,5", :order => "rating desc")
  end
  
  def new
	  @new_video = Video.new
  end
  
  def create
    new_video = Video.new(params[:video])
    if new_video.save
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end
  
  def delete
    
  end
end
