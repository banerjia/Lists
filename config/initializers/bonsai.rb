ENV['ELASTICSEARCH_URL'] = 'http://zjfnv9lx:egxemnygttpfpaqd@ash-9154894.us-east-1.bonsai.io'

Tire.configure do
	url ENV['ELASTICSEARCH_URL']
end
