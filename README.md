# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.io](https://voltos.io)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them securely as environment variables, and you can more easily manage & access them. 

## Contents
* [Installation](#installation)
* [Using Voltos](#using-voltos)
* [Deploying to Heroku](#deploying-to-heroku)
* [Contributing](#contributing)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltos'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install voltos
    
### Troubleshooting installation

**Ubuntu**

You may need to install native extensions first:

    $ sudo apt-get install libcurl4-openssl-dev

## Using Voltos
Using Voltos to manage your credentials and secrets is generally the same across all platforms. Check out the general docs at:

* [Getting started](https://github.com/gluio/voltos-docs/blob/master/README.md#getting-started)
* [Using Voltos with your apps](https://github.com/gluio/voltos-docs/blob/master/README.md#using-voltos-with-your-apps)


## Deploying to Heroku
Ensure your Heroku app is packaging the `voltos` gem in your Gemfile.

Update your `Procfile` to run your process using `voltos`

    web: voltos run "puma -C config/puma.rb"

Manually retrieve the API token for the selected bundle

    $ voltos use your-voltos-bundle
    Setting current bundle in use to 'your-voltos-bundle'... ⣻

    $ voltos token
    Fetching token... ⣻

    New API token for 'your-voltos-bundle' is: cbff7be5112287c39dad41c643761a84
    Please store this securely, this is the only time it will be displayed and it can not be retrieved again
    (though you can request a new one)
    
Then add the API token to the Heroku config variables for your app

    $ heroku config:set VOLTOS_KEY=cbff7be5112287c39dad41c643761a84

On startup, `voltos` will securely retrieve your bundle's credentials and make them available to your app.

Anytime you need to update your credentials: do so via the CLI or web app, `heroku restart` your app, and the updated credentials are loaded up to your app again.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gluio/voltos-ruby

