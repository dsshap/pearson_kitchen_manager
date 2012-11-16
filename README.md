# PearsonKitchenManager

    API wrapper for Pearson Kitchen Manager

## Installation

Add this line to your application's Gemfile:

    gem 'pearson_kitchen_manager'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pearson_kitchen_manager

##Requirements

A Pearson account and API key. You can see your API keys [here](http://developer.pearson.com/sdm/myprofile).

## Usage

    pkm = PearsonKitchenManager.new("your_api_key")

> Note: In an effort to simplify PearsonKitchenManager, you can use 'MAILCHIMP_API_KEY' in the environment variable instead of passing it.
Fetching data is as simple as calling API methods directly on the wrapper
object.  The API calls may be made with either camelcase or  underscore
separated formatting as you see in the "More Advanced Examples" section below.

Check the API [documentation](http://developer.pearson.com/api/pearson-kitchen-manager/apimethod/courses/190/overview) for details.

### Fetching Recipes

For example, to fetch your first 100 recipes (offset 0):

    recipes = pkm.recipes({offset: 0, limit: 100})

### Fetching Recipe

For example, to fetch your first 100 recipes (offset 0):

    recipe = pkm.recipes(url_extension: "recipe_id")

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
