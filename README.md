# Citysdk

A Ruby client for the CitySDK API.

[![Code Climate](https://codeclimate.com/github/foxdog-studios/citysdk-client.png)](https://codeclimate.com/github/foxdog-studios/citysdk-client)


## Example usage

```ruby
require 'citysdk'
require 'pp'

# Create an API client for your CitySDK API.
api = CitySDK::API.new('https://api.example.com')

# Get the first 10 layers (credentials are not required).
pp api.get_layers()

# Enter your credentials so that can write to the API.
api.set_credentials('john.smith@example.com', 'password')

# Create a layer within a domain that you're a member of.
api.create_layer(
    name:         'my_domain.my_layer',
    description:  'Example layer',
    organization: 'Example Co.',
    category:     'civil.example'
)

# Go through paginated results
railway_station_node_iterator = CitySDK::NodesPaginator.new(api,
    'layer' => 'osm',
    'osm::railway' => 'station',
)
stations = []
while railway_station_node_iterator.has_next()
    api_results = railway_station_node_iterator.next()
    stations.concat api_results.fetch('results')
end # while
pp stations

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

