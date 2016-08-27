# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.io](https://voltos.io)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them securely as environment variables, and you can more easily manage & access them. 

## Contents
* [Installation](#installation)
* [Getting started](#getting-started)
* [Using Voltos with your apps](#using-voltos-with-your-apps)
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

## Getting started

### Sign up
```
$ voltos signup
```

### Sign in
```
$ voltos auth
```

### Create bundle of credentials
```
$ voltos create piedpiper-backend
```

### Add credentials to bundle
```
## add to default bundle in use
$ voltos set MAILSERVICE=17263ed6547a7c7d8372
$ voltos set DEV_URL=https://dev.piedpiper.io

## or explicitly specify which bundle:
$ voltos set MAILSERVICE=17263ed6547a7c7d8372 piedpiper-backend
$ voltos set DEV_URL=https://dev.piedpiper.io piedpiper-backend
```

### List credentials in a bundle
```
$ voltos list
```

### List all bundles of credentials that you can access
```
$ voltos list --all
```

### Share bundle of credentials
```
$ voltos share sasha@hooli.com
```

### Unshare bundle of credentials
```
$ voltos retract piedpiper-backend sasha@hooli.com
```

### Remove credentials
```
$ voltos unset piedpiper-backend DEV_URL
```

### Destroy bundle of credentials
```
$ voltos destroy piedpiper-backend
```


## Using Voltos with your apps

When you're done loading up your bundles with credentials, you'll want to start using them with your apps.

### Running locally

Select a bundle of credentials that your app will use
```
$ voltos use piedpiper-backend
```
Then run your app inside a `voltos` process: your app will have access to the bundle of credentials currently in use
```
$ voltos run "rake customers:update"

# runs the rake task customers:update, which can access credentials in the 
# bundle `piedpiper-backend` as environment variables

$ voltos run "rails s -p $PORT"

# runs a rails app server on a given port, which can access credentials in the
# bundle `piedpiper-backend` as environment variables
```

**How it works:** `voltos` securely retrieves an API token for the selected bundle and stores it in `.env` as `VOLTOS_KEY`. `voltos` will use `VOLTOS_KEY` any time it needs to access, manage and switch between bundles of credentials. `.env` is also added to `.gitignore` to protect against accidental source commit. 

### Deploying to Heroku
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

