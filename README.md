# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.online](https://voltos.online)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them, and you can more easily manage them & access to them. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltos'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install voltos

## Getting started

You'll use Voltos to load up a **bundle** of credentials each time. Think of a bundle as credentials that have been logically grouped together, e.g. a ``PROD`` bundle.

1. Ensure your bundle(s) are organised how you want, on your Voltos account (https://voltos.online).

2. Find the API key for the bundle that you want your app to load (e.g. bundle ``PROD``'s API key: 13579def13579def)

2. Set this key as an environment variable in your app, e.g.
   ```ruby
   $ export VOLTOS_KEY=13579def13579def

   # or on a platform like Heroku
   $ heroku config:set VOLTOS_KEY=13579def13579def
   ```
   In a moment, we'll use this key to load up the matching Voltos bundle of credentials (and don't worry, you'll only need to set one environment variable this way).

3. Require the `voltos` gem early on, before you use the credentials:
   ```ruby
   require 'voltos'
   
   # Voltos will automatically load the bundle matching the key you've specified in VOLTOS_KEY
   # and load those credentials into ENV, ready to use
   
   puts ENV['MY_SECRET_KEY']
    ```

### Multiple bundles

Sometimes, you need to load up more than one bundle (e.g. you have ``DEV`` and ``PROD`` bundles to load when deploying on different environments).

1. Get the respective API keys for those bundles (e.g. ``VOLTOS_COMMON`` and ``VOLTOS_PROD``).

2. Set environment variables for these bundle keys:
   ```ruby
   $ export VOLTOS_COMMON=1294854fe52417a
   $ export VOLTOS_PROD=8646ec352729c3
   
   # or on a platform like Heroku
   $ heroku config:set VOLTOS_COMMON=1294854fe52417a VOLTOS_PROD=8646ec352729c3
   ```

2. Manually load up each bundle of credentials at appropriate time for your app:
   ```ruby
   
   ## environment.rb - load up COMMON bundle with credentials common to all environments
   Voltos.configure do |config|
     config.api_key = ENV["VOLTOS_COMMON"]
   end
   
   voltos_creds = Voltos.load
   voltos_creds.each do |key,val|
     ENV[key] ||= val
   end


   ## production.rb - load up PROD bundle with credentials specific to prod environment
   Voltos.configure do |config|
     config.api_key = ENV["VOLTOS_PROD"]
   end
   
   voltos_creds = Voltos.load
   voltos_creds.each do |key,val|
     ENV[key] ||= val
   end
   ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voltos-online/voltos-ruby

