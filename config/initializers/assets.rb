# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( policy_pepole.css policy_divisions.css users/registrations.css users/confirmations.css users/passwords.css users/sessions.css about.scss  bootstrap.css  bootstrap.css.map  divisions.scss policies.css errors.scss  help.scss  home.scss  people.scss  style.css  sumisne_holosuvannia.scss media.scss  ukr_datepiker.js html2canvas.js)
