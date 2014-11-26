class VideosController < ApplicationController

	def index
		@page_title = "Entries"
		if !params[:q].present?
			@recently_added = Video.where( {active: true, created_at: 7.years.ago..DateTime.now}).limit(20).order(:created_at)
			
			@top_videos = Video.where( {active: true, rating: [1..5]}).limit(20).order(rating: :desc)
			
			@validation_failed = Video.where( "validated_at = updated_at and active=0" ).order(validated_at: :desc)
			@deleted_videos = VideosArchive.all.order(updated_at: :desc)
			@inactive_videos = Video.where({:active => false}).order(updated_at: :desc)
		else
			@search_results = Video.search( params )
		end		
	end

	def new
		@page_title = "Add a New Video"
		@video = Video.new( {:active => true })
	end

	def create
		new_video = Video.new(params[:video])
		if new_video.save			
			flash[:notice] = "Video <em>#{new_video[:title]}</em> has been saved"
			redirect_to :action => (params[:commit] == "Save" ? "index" : "new")
		else
			@video = new_video
			@page_title = "Add a New Video"
			render :action => "new"
		end
	end

	def edit
		@video = Video.find( params[:id] )
		@page_title = "Edit: #{@video[:title]}"
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
		Video.find( params[:id] ).destroy
		redirect_to :action => "index"
	end

private
	def store_params
		params.require(:video).permit(:title, :description, :url, :image_url, :rating)
	end	
end
