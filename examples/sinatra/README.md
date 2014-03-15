## Example of how to include assets in a Sintra app

### What are the requirements?

* Ruby 1.9.3+
* node.js 0.8+

### How to set it up?

Given you have Ruby and node.js available run:

```bash
bundle install
npm install
```

### How to run in in development mode?

```
ruby app.rb
```

and point your browser to [localhost:4567](http://localhost:4567)

### How to run in in production mode?

```bash
./node_modules/.bin/assetspkg -b -c assets.yml
RACK_ENV=production ruby app.rb
```

and point your browser to [localhost:4567](http://localhost:4567)
