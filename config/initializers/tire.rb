Tire.configure do 
	Video.tire.index.import Video.find(:all, :include => :site )
end
