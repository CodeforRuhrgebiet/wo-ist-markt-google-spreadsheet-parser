class Market
  def self.parse_raw_data(row)


    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [row[6], row[5]]
      },
      properties: {
        title: row[1],
        location: row[2],
        opening_hours: row[3]
      }
    }
  end
end
