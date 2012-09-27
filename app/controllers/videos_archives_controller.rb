class VideosArchivesController < ApplicationController
  def destroy
    VideosArchive.find(params[:id]).destroy
    redirect_to :controller => "videos", :action => "index"
  end
end