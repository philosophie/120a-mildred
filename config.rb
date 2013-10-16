require "frizz/middleman/extension"
activate :frizz

configure :build do
  set :fonts_dir, "fonts"

  # Manifest should specify which nested scripts to compile
  ignore "javascripts/application/*"
  ignore "stylesheets/application/*"
  ignore "stylesheets/_*"
  ignore "vendor/*"

  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
end

after_configuration do
  sprockets.append_path "vendor/javascripts"
  sprockets.append_path "vendor/stylesheets"
end