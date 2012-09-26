class VideosController < ApplicationController
  def index
    @page_title = "Rich Media"
    @browser_title = "Diplomacy"
    @recently_added = Video.find(:all, :conditions => ["active = ? and created_at >= ?", 1, 7.days.ago], :limit => "0,5", :order => "created_at desc")
    @top_videos = Video.find(:all, :conditions => ["active = ? and rating >= ? ", 1, 5 ], :limit => "0,5", :order => "rating desc")
  end

  def new
    @video = Video.new
  end

  def create
    new_video = Video.new(params[:video])
    if new_video.save     
      redirect_to :action => (params[:commit] == "Save" ? "index" : "new")
    else
	  @video = new_video
      render :action => "new"
    end
  end
  
  def edit
    @video = Video.find( params[:id] )
  end

  def update
    video_to_update = Video.find( params[:id] )
    if video_to_update.update_attributes( params[:video])
      redirect_to :action => "index"
    else
      redirect_to :action => "edit"
    end
  end

  def destroy
    Video.mark_for_deletion( params[:id] )
    redirect_to :action => "index"
  end
end
