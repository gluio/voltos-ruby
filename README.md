# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.io](https://voltos.io)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them securely as environment variables, and you can more easily manage & access them. 

## Contents
* [Installation](#installation)
* [Getting started](#getting-started)
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
```
sudo apt-get install libcurl4-openssl-dev
```



## Deploying to Heroku
Ensure your Heroku app is packaging the `voltos` gem in your Gemfile.

Update your `Procfile` to run your process using `voltos`
```
web: voltos run "puma -C config/puma.rb"
```

Manually retrieve the API token for the selected bundle
```
$ voltos token
```
Then add the API token to the Heroku config variables for your app
```
# assuming your bundle's API token is: 8ce32acd9437efe9ef55c39e44dea337
$ heroku config:set 8ce32acd9437efe9ef55c39e44dea337
```

On startup, `voltos` will securely retrieve your bundle's credentials and make them available to your app.

Anytime you need to update your credentials: do so via the CLI or web app, `heroku restart` your app, and the updated credentials are loaded up to your app again.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gluio/voltos-ruby

