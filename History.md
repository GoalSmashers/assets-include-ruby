[2.0.0 / 2014-05-03](https://github.com/GoalSmashers/assets-include-ruby/compare/v2.0.0...v1.0.1)
==================

* Changes AssetsInclude::Base to accept a hash instead of a block in initializer.

[1.0.1 / 2014-04-27](https://github.com/GoalSmashers/assets-include-ruby/compare/v1.0.0...v1.0.1)
==================

* Fixes passing configuration variables to AssetsInclude.helpers.

1.0.0 / 2014-03-15
==================

* Provides 1:1 mapping with `assetsinc` 1.1 API.
* Provides Sinatra helpers providing the same features as node version.
* Provides Sinatra examples.
* Provides a #reset option to empty includer's cache.
* Defaults to bundled mode if RACK_ENV variable is set to production.
* Defaults cache_boosters to true as it is a more sane option.
