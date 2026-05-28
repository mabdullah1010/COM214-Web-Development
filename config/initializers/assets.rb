# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# On Windows, Sprockets' atomic file rename causes EACCES errors.
# Bypass the file-based cache entirely in development.
if Rails.env.development?
  Rails.application.config.assets.configure do |env|
    env.cache = ActiveSupport::Cache::NullStore.new
  end
end

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
