require 'bundler/setup'
Bundler.setup

require 'sinatra'
require 'assets_include'

helpers AssetsInclude.helpers

get '/' do
  erb :index
end

__END__

@@ layout
<html>
<head>
  <title>Showcase</title>
  <%= assets.group('stylesheets/all.css') %>
</head>
<body>
  <%= yield %>
  <%= assets.group('javascripts/all.js') %>
</body>
</html>

@@ index
<h1>Assets-includer-ruby showcase</h1>
<p>CSS and JavaScript are included via <span class="pre">assets.group</span> calls (see source in app.rb)</p>
