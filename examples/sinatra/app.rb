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
<p>Here's a list of all CSS assets (you can get it programaticaly):</p>
<ol>
  <% assets.list('stylesheets/all.css').each do |asset| %>
    <li><%= asset %></li>
  <% end %>
</ol>
<p>and a list of all JavaScript ones:</p>
<ol>
  <% assets.list('javascripts/all.js').each do |asset| %>
    <li><%= asset %></li>
  <% end %>
</ol>
<p class="js-inline-placeholder"></p>
<%= assets.inline('javascripts/inline.js') %>
