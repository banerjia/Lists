ENV['ELASTICSEARCH_URL'] = ENV['BONSAI_URL']

Tire.configure do
	url ENV['ELASTICSEARCH_URL']
end
