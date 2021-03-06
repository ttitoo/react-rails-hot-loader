# React::Rails::HotLoader 

Reload React.js components with Ruby on Rails & [`react-rails`](http://github.com/reactjs/react-rails).

When you edit components, they'll be reloaded by the browser & re-mounted in the page.

[![Gem Version](https://badge.fury.io/rb/react-rails-hot-loader.svg)](http://badge.fury.io/rb/react-rails-hot-loader) [![Build Status](https://travis-ci.org/rmosolgo/react-rails-hot-loader.svg)](https://travis-ci.org/rmosolgo/react-rails-hot-loader) [![Code Climate](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/badges/gpa.svg)](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader) [![Test Coverage](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/badges/coverage.svg)](https://codeclimate.com/github/rmosolgo/react-rails-hot-loader/coverage) 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'react-rails-hot-loader'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install react-rails-hot-loader

## Usage

- Add an initializer:

  ```ruby
  # app/config/initializers/react_rails_hot_loader.rb
  if Rails.env.development?
    React::Rails::HotLoader.start()
  end
  ```

- Include the JavaScript:

  ```js
  // app/assets/javascripts/application.js
  //= require react-rails-hot-loader
  ```

  (When not `Rails.env.development?`, this requires an empty file, so don't worry about leaving it in production deploys.)

- Restart your development server

- Edit files in `/app/assets/javascripts` & save changes -- they'll be reloaded in the client and React components will be remounted.

## Doeses & Doesn'ts

`react-rails-hot-loader` ...

- __does__ set up a WebSocket server & client
- __does__ reload JS assets when they change (from `/app/assets/javascripts/*.js*`)
- __does__ remount components (via `ReactRailsUJS`) after reloading assets
- __does__ preserve state & props (because `React.render` does that out of the box)
- __doesn't__ reload Rails view files (`html`, `erb`, `slim`, etc)
- __doesn't__ reload CSS (although that could be fixed)

## TODO

- Handle Passenger occasionally killing background threads :(
- Replace pinging with file watching
- Add `rails g react-rails-hot-loader:install` to add initializer and JS

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
