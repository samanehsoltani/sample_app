source 'https://rubygems.org'

gem 'rails',                '4.2.0'
gem 'bcrypt',               '3.1.7' #To make the password , has_secure_password uses a state-of-the-art hash function called bcrypt.
gem 'faker',                '1.4.2' #allows us to make sample users with semi-realistic names and email addresses
gem 'carrierwave',             '0.10.0' #image uploader
gem 'mini_magick',             '3.8.0' #image resizing
gem 'fog',                     '1.23.0' #image upload in production
gem 'will_paginate',        '3.0.7' #pagination methods
gem 'bootstrap-will_paginate', '0.0.10' #configures will_paginate to use Bootstrap’s pagination styles
gem 'bootstrap-sass',       '3.2.0.0'
gem 'sass-rails',           '5.0.1'
gem 'uglifier',             '2.5.3'
gem 'coffee-rails',         '4.1.0'
gem 'jquery-rails',         '4.0.3'
gem 'turbolinks',           '2.3.0'
gem 'jbuilder',             '2.2.3'
gem 'sdoc',                 '0.4.0', group: :doc

group :development, :test do
  gem 'sqlite3',     '1.3.9'
  gem 'byebug',      '3.4.0'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'pg',             '0.17.1'
  gem 'rails_12factor', '0.0.2'
end