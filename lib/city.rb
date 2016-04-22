class City
  def initialize(config)
    @config = config
    @market_features = []
  end

  def download_market_data!
    puts "# Downloading raw data for #{@config['name']}"
    spreadsheet_url = "https://docs.google.com/spreadsheets/d/#{@config['spreadsheet']['id']}/export?format=tsv&gid=#{@config['spreadsheet']['gid']}"
    spreadsheet_file = open(spreadsheet_url).read
    File.open("#{@@project_root}/raw/#{@config['file_name']}.tsv", 'w') { |file| file.print spreadsheet_file }
  end

  def parse_raw_data!
    csv_file = CSV.read("#{@@project_root}/raw/#{@config['file_name']}.tsv", { col_sep: "\t" })
    csv_file.each do |row|
      if row[0] == '§'
        @market_features.push(Market.parse_raw_data(row))
      end
    end
  end

  def generate_json_file!
    puts "# Saving json file for #{@config['name']}"
    pretty_json = JSON.pretty_generate(json_data)
    File.open("#{@@project_root}/result/#{@config['file_name']}.json", 'w') { |file| file.print pretty_json }
  end

  private

  def json_data
    {
      crs: crs,
      type: 'FeatureCollection',
      features: @market_features,
      metadata: metadata
    }
  end

  def metadata
    {
      data_source: {
        title: @config['metadata']['data_source']['title'],
        url: @config['metadata']['data_source']['url']
      },
      map_initialization: {
        coordinates: @config['metadata']['map_initialization']['coordinates'],
        zoom_level: @config['metadata']['map_initialization']['zoom_level']
      }
    }
  end

  def crs
    {
      properties: {
        name: 'urn:ogc:def:crs:OGC:1.3:CRS84'
      },
      type: 'name'
    }
  end
end
