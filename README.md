# Voltos Ruby bindings

This gem provides Voltos Ruby bindings to access the Voltos API from apps written in Ruby. Voltos ([https://voltos.online](https://voltos.online)) provides credentials-as-a-service for app and system developers.

Voltos stores your credentials (e.g. API keys, usernames, passwords, tokens) in a secure, central location - so that your apps can access them, and you can more easily manage them & access to them. 

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

=== Sign up for a new account
Enter your email address: jane@company.com
jane@company.com
Creating account... ⣾ 

New account created. Please check your email inbox and click the link to confirm your email address.
```

### Sign in

```
$ voltos auth
(Press CTRL^C to sign up for a new account)
Enter your email address: jane@company.com
jane@thedanielmay.com
Password: foobar
**********
Authenticating account... ⢿ 
$
```

### Create bundle of credentials

```
$ voltos create piedpiper-backend
Creating bundle... ⣻ 

Created a new bundle: piedpiper-backend
▸ Bundle in use: piedpiper-backend
```

### Add credentials to bundle

```
## add to default bundle in use
$ voltos set MAILSERVICE=17263ed6547a7c7d8372
$ voltos set DEV_URL=https:///dev.piedpiper.io

## or:
$ voltos set MAILSERVICE=17263ed6547a7c7d8372 piedpiper-backend
$ voltos set DEV_URL=https:///dev.piedpiper.io piedpiper-backend
```

### List credentials in a bundle

```
$ voltos list
Fetching credentials... ⣽ 
=== piedpiper-backend credentials
DEV_URL         : https://dev.piedpiper.io
MAILSERVICE     : 17263ed6547a7c7d8372
▸ Bundle in use: piedpiper-backend
```

### List all your credentials

```
$ voltos list --all
Listing bundles... ⣽ 
=== Your bundles
geoserver-test
geoserver-prod
piedpiper-backend
cloudDrive
▸ Bundle in use: piedpiper-backend
```


### Share credentials



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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/voltos-online/voltos-ruby

