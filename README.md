# Marr (Memereply Api Rescue Response)

Dynamically handle exceptions and render a structured JSON response to client applications.
Formerly (Memereply sad pepe)

![sad pepe on the floor](https://www.meme-arsenal.com/memes/1adf62bd401ea536f9e6d4df9097201b.jpg)
![pepe the enginer](https://images-cdn.9gag.com/photo/ajq1ePg_700b.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'marr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marr

## Example Response

```json
{
  "errors": {
    "code": "GroupError",
    "title": "GroupInvalid",
    "detail": "The Group can not be saved. Invalid or missing data.",
    "meta": {
      "object_errors": [
        {
          "pointer": "owner",
          "detail": "Owner can't be blank"
        },
        {
          "pointer": "name",
          "detail": "Name can't be blank"
        }
      ],
      "trace_id": "6CA01AF9E592595F"
    }
  }
}
```

## Usage

There is a method automatically created for each each class that inherits from Marr::ApiError. The method is preprended with 'raise'.

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
Marr::Api::Error.configure do |config|
  config.namespaces = ['Api::V1::Errors']
  config.trace_id_length = 16
end
```

Create a new Error that inherits from the ApiError class. The class needs to be under the configured name space. NOTE: The `message` method must be implemented.

```ruby
module Api
  module V1
    module Errors
      class MemeError < ::Marr::ApiError
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
include ::Marr::Api::ErrorEngine
```

Next rescue all your api errors. This method could be in your base api class.

```ruby
rescue_from 'Marr::ApiError' do |exception|
  render exception.render, status: exception.status
end
```

If you are custom rendering using a gem like Jbuilder you can do something like this:

```ruby
# you would overide the custom_render in your class to return the file path you want to use
#=> 'api/internal/v1/errors/error'
rescue_from 'Marr::ApiError' do |error|
  @error = error
  render @error.render, status: @error.status
end
```
