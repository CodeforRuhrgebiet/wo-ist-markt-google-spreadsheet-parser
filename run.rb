require 'yaml'
require 'open-uri'
require 'csv'
require 'json'

@@project_root = File.expand_path(File.dirname(__FILE__))
Dir["#{@@project_root}/lib/*.rb"].each {|file| require file }

city_entries = YAML.load_file("#{@@project_root}/cities.yml")
city_entries.each do |config|
  city = City.new(config)
  city.download_market_data!
  city.parse_raw_data!
  city.generate_json_file!
end

exit
