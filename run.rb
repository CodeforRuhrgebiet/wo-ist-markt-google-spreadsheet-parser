require 'csv'
require 'json'

csv_file = CSV.read("./wochenmaerkte.csv.tsv", { col_sep: "\t" })

features = []

csv_file.each_with_index do |row, index|
  if index != 0 && row[6] && row[5]
    feature = {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [row[6], row[5]]
      },
      properties: {
        title: row[2],
        location: row[2],
        opening_hours: row[7]
      }
    }

    features.push(feature)
  end
end

data = {
  crs: {
    properties: {
      name: "urn:ogc:def:crs:OGC:1.3:CRS84"
    },
    type: "name"
  },
  type: 'FeatureCollection',
  features: features,
  metadata: {
    data_source: {
      title: "Daten von der EVB",
      url: "https://www.essen.de/rathaus/aemter/ordner_32/Wochenmaerkte.de.html"
     },
     map_initialization: {
      "coordinates": [ 7.011837, 51.456474 ],
      "zoom_level": 11
    }
  }
}

File.open("./essen.json", 'w') { |file| file.print data.to_json }
