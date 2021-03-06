class Video < ActiveRecord::Base
	require 'uri'
	require 'net/http'
  include Tire::Model::Search
  include Tire::Model::Callbacks

	belongs_to :site, :counter_cache => true
	attr_accessible :description, :image_url, :rating, :tags, :title, :url, :active

	validates :title, :presence => "The entry needs a title."
	validates :url, :presence => {:message => 'Need a URL dummy'}, :format => {:with => URI.regexp, :message => 'Check the format idiot' }
	validates_uniqueness_of :unique_url, :case_sensitive => false, :message => "URL already present", :if => Proc.new { |video| video.url_changed? }

	tire do 
		index_name( "videos" )
		mapping do 
			indexes :id,				:type => 'integer',			:index => 'not_analyzed'
			indexes :site_id,		:type => 'integer',			:index => 'not_analyzed'
			indexes :site_name,	:type => 'string', 			:index => 'not_analyzed',	:as => 'site[:title]',	:incude_in_all => false
			indexes :rating,		:type => 'integer',			:index => 'not_analyzed'
			indexes :title,			:type => 'string',			:analyzer => 'snowball'
			indexes :created_at,:type => 'date',				:index => 'not_analyzed'
		end
	end


	# Callback Methods
	before_save do |video|
		return if !video.url_changed? 
		site = Site.find_or_create_by_domain(extract_domain(video[:url]), :title => extract_domain(video[:url]))
		video[:site_id]= site[:id]
	end

	before_validation do |video|
		return if (!video.url_changed? || video[:url].nil?) && !video[:title].empty?
		if video[:title].empty?
			doc = Net::HTTP.get( URI( video[:url] ) )
			domain = extract_domain(video[:url])
			video[:title] = extract_content( doc, domain, "title_pattern")
			video[:description] = extract_content( doc, domain, "description_pattern") if video[:description].empty?
			video[:image_url] = extract_content( doc, domain, "image_pattern") if video[:image_url].empty?
		end
		video[:url] = video[:url].strip.sub( /\/$/,'')
		video[:unique_url] = extract_unique_url( video[:url] )
	end

	# Instance Methods
	def destroy
		video_to_archive = VideosArchive.new()
		self.attributes.each do |key,value|
			video_to_archive[key] = value unless key == "updated_at" || key == "active"
		end
		video_to_archive.save
		super    
	end

	# Class Methods
	def self.validate_urls
		success_codes = (200..207).to_a.append(226) + (300..307).to_a
		entries_to_validate = find(:all, :conditions => ["validated_at >= ? ||  validated_at IS NULL", 6.days.ago.to_date], :select => [:id, :url, :validated_at, :active] )
		entries_to_validate.each do |entry|
			valid_url = true
			begin
				url_response = Net::HTTP.get_response( URI.parse( entry[:url] ) )
				valid_url = !success_codes.index(url_response.code.to_i).nil?
			rescue 
				valid_url = false
			end
			entry[:active] = valid_url
			entry[:validated_at] = Time.now
			entry.save!(:validate => false)
		end
	end
	
	def self.search( params = {} )
		params[:page] ||= 1
		params[:per_page] ||= 10
		query = params[:q].present? && !params[:q].blank? ? params[:q] : '*'
		results = tire.search :per_page => params[:per_page] , :page => params[:page] do
			query do
				boolean do
					must {string query}
				end
			end
			
		end
		
		return_value = nil
		
		if results.total > 0
			return_value = Hash.new
			return_value[:results] = results.results
			return_value[:count] = results.total
			return_value[:more_pages] = params[:page] < results.total_pages
			return_value[:q] = params[:q]
		end
		
		return return_value
		
	end

	# Private Methods
	private

	def extract_domain( url )
		url_pattern = /\:\/\/(.*\.)?([a-zA-Z0-9\-\_]+(\.(([a-zA-Z]{2})|gov|com|biz|net|xxx|edu|org|pro|tel|mil|int|([a-zA-Z]{4})))+)\//
			url_pattern.match(url)[2]
	end


	def extract_content( response, domain, attribute )
		attr_sym = attribute.to_sym
		pattern = Site.find( :first, :conditions => {:domain => domain}, :select => attr_sym )
		return nil if pattern.nil? || pattern[attr_sym].nil?
		matches = response.match( Regexp.new( pattern[attr_sym] ) )
		matches[1].strip unless matches.nil?    
	end

	def extract_unique_url( url )
		url_pattern = /^http(s){0,1}\:\/\/(www\.)?/
			url.sub( url_pattern, "")
	end
end
