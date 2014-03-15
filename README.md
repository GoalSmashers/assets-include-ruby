[![Build Status](https://secure.travis-ci.org/GoalSmashers/assets-include-ruby.png)](https://travis-ci.org/GoalSmashers/assets-include-ruby)
[![Code Climate](https://codeclimate.com/github/GoalSmashers/assets-include-ruby.png)](https://codeclimate.com/github/GoalSmashers/assets-include-ruby)
[![Code Climate](https://codeclimate.com/github/GoalSmashers/assets-include-ruby/coverage.png)](https://codeclimate.com/github/GoalSmashers/assets-include-ruby)

## What is assets-include-ruby?

Assets-include is a Ruby wrapper around [Assets-Include](https://github.com/GoalSmashers/assets-include) for including your assets in HTML views.

See [example apps](https://github.com/GoalSmashers/assets-include-ruby/tree/master/examples) for real-world use cases.

## Usage

### What are the requirements?

```
Ruby 1.9.3+
Node.js 0.8.0+
```

### How to install assets-include-ruby?

```
gem install assets_include
```

### How to use assets-include-ruby?

With [Sinatra](https://github.com/sinatra/sinatra):

```ruby
require 'sinatra'
require 'assets_include'

# Adds assets.(group|list|inline) helpers
helpers AssetsInclude.helpers

get '/' do
  erb :index
end

__END__

@@ layout
<html>
<head>
  <%= assets.group('stylesheets/all.css') %>
</head>
<body>
  <%= yield %>
  <%= assets.group('javascripts/all.js') %>
</body>
</html>

@@ index
<h1>Yay, all assets are in</h1>
```

AssetsInclude.helpers accepts an options hash, i.e.,

* `bundled` - `true` for bundled, production mode, `false` for development mode
* `config` - path to configuration file, defaults to ./assets.yml
* `root` - root path of all assets, defaults to ./public under config's path
* `cache_boosters` - `true` for cache boosters (timestamp in dev mode, md5 for bundled, production files)
* `asset_hosts` - prefixes all paths with given asset host(s)
* `loading_mode` - `async` or `defer` for JavaScript assets' loading mode

and adds the following methods to your views:

* `assets.group(locator)` - returns a list of `<script>` or `<link>` tags for JavaScript or CSS assets respectively
* `assets.inline(locator)` - returns inlined JavaScript or CSS assets. In development mode works the same way as `#group`.
* `assets.list(locator)` - returns an array of assets files to easily embed them into JavaScript or data attributes.

## License

Assets-include-ruby is released under the [MIT License](https://github.com/GoalSmashers/assets-include-ruby/blob/master/LICENSE).
