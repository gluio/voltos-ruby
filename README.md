# Voltos Ruby bindings

This gem provides Voltos Ruby bindings for provide a small SDK for access to the Voltos API from apps written in Ruby. Voltos ([https://voltos.online](https://voltos.online)) provides credentials-as-a-service for app and system developers.

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

1. Find your unique Voltos API key. See "Account" settings.

2. Set this key as an environment variable, e.g.
   ```ruby
   $ export VOLTOS_KEY=13579def13579def
   
   # or on a platform like Heroku
   $ heroku config:set VOLTOS_KEY=13579def13579def   
   ```
   We'll use this key to load up our Voltos credentials (don't worry, you'll only need to set one key this way).
   
3. Load up the Voltos credentials. You'll probably want them early on, prior to where your trying to use them (e.g. in ``environment.rb`` in Rails).
   ```ruby
    Voltos.configure do |config|
      config.api_key = ENV["VOLTOS_KEY"]
    end

    # load all the bundles of credentials for that API key
    Voltos.load

    # access the credential "MAILER_API_TOKEN" that's in the "myapp-prod" bundle
    ENV["MAILER_API_TOKEN"] = Voltos.key("myapp-prod", "MAILER_API_TOKEN")
    ```
    Note that we're grabbing the credential and stashing it in an environment variable (``MAILER_API_TOKEN``). This fits pretty well with existing idiom, plus ensures that existing code using environment variables keeps working with no change.

4. You can load different credentials for different environments. For example: let's say you've bundled your credentials into ``myapp-dev`` and ``myapp-prod`` bundles (for development and production environments, respectively). 

    In ``config/environments/development.rb``:

   ```ruby
    Voltos.configure do |config|
      config.api_key = ENV["VOLTOS_KEY"]
    end

    Voltos.load
    ENV["ANALYTICS_KEY"] = Voltos.key("myapp-dev", "ANALYTICS_KEY")
    ```

    Then in ``config/environments/production.rb``:

   ```ruby
    Voltos.configure do |config|
      config.api_key = ENV["VOLTOS_KEY"]
    end

    Voltos.load
    ENV["ANALYTICS_KEY"] = Voltos.key("myapp-prod", "ANALYTICS_KEY")
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voltos-online/voltos-ruby

