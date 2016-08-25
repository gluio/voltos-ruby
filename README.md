# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.online](https://voltos.online)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them, and you can more easily manage them & access to them. 

## Contents
* [Installation](#installation)
* [Getting started](#getting-started)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'voltos', '~> 0.3.0rc14'
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

### Deploying to Heroku


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voltos-online/voltos-ruby

