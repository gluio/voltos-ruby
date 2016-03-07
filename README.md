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

1. Find your unique Voltos API key. See "Bundle" settings.

2. Set this key as an environment variable, e.g.
   ```ruby
   $ export VOLTOS_KEY=13579def13579def

   # or on a platform like Heroku
   $ heroku config:set VOLTOS_KEY=13579def13579def
   ```
   We'll use this key to load up our Voltos credentials (don't worry, you'll only need to set one key this way).

3. Require the `voltos` gem early on, prior to where your trying to use any credentials
   ```ruby
   require 'voltos'
    # access the credential "MAILER_API_TOKEN" that's in the bundle
    puts ENV["MAILER_API_TOKEN"]
    ```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voltos-online/voltos-ruby

