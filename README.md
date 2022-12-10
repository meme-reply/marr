# Memereply Sad Pepe
Dynamically handle exceptions and render a structured JSON response to client applications

![sad pepe on the floor](https://www.meme-arsenal.com/memes/1adf62bd401ea536f9e6d4df9097201b.jpg)
![pepe the enginer](https://images-cdn.9gag.com/photo/ajq1ePg_700b.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'memereply_sad_pepe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memereply_sad_pepe

## Example Response

```json
{
    "error": {
        "trace_id": "6CA01AF9E592595F",
        "type": "GroupError",
        "message": "There was an issue processing the Group",
        "error_subcode": "GroupInvalid",
        "detail": "The Group can not be saved. Invalid and missing data.",
        "sub_errors": [
            {
                "pointer": "user",
                "detail": "User can't be blank"
            },
            {
                "pointer": "name",
                "detail": "Name can't be blank"
            }
        ]
    }
}
```

## Usage
There is a method automatically created for each each class that inherits from Memereply::ApiError. The method is preprended with 'raise'.
```ruby
  raise_meme_error
```

You can also pass in options to your method for a more robust response:
```ruby
  raise_meme_error(controller: self, subcode: :meme_invalid, object: @meme)
```

## Setup
Configure the gem. For the gem to recognize the descendant classes you have to provide the name space the errors are under.
```ruby
Memereply::Api::Error.configure do |config|
  config.namespaces = ['Api::V1::Errors']
  config.trace_id_length = 16
end
```

Create a new Error that inherits from the ApiError class. The class needs to be under the configured name space. NOTE: The ``message`` method must be implemented.

```ruby
module Api
  module V1
    module Errors
      class MemeError < ::Memereply::ApiError
        def message
          "There was an issue processing the meme"
        end

        def subcodes
          super({
            meme_invalid: 'This meme is invalid.',
            meme_too_large: 'This meme is too damn big nephew', 
          })
        end
      end
    end 
  end 
end 
```

Include the ErrorEngine module in your base api class
```ruby
include ::Memereply::Api::ErrorEngine
```

Next rescue all your api errors. This method could be in your base api class.
```ruby
rescue_from 'Memereply::ApiError' do |exception|
  render json: exception.render, status: exception.status
end
```
