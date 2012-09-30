# Learn more: http://github.com/javan/whenever

every :sunday, :at => "9:59pm" do
	runner "VideosArchive.purge_old_entries"
	runner "Video.validate_urls"
end