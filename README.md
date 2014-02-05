# Citysdk

A Ruby client for the CitySDK API.


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
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

