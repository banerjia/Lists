require 'yaml'
AppConfig = YAML.load_file("config/custom_config.yml")
AppConfig.each do |key, value |
  ENV[key.to_s] = value.to_s
end
RAILS_ENV = ENV['RAILS_ENV']

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Lists::Application.initialize!
