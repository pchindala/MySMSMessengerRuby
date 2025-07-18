# config/initializers/ssl_redirect.rb
if Rails.env.production?
  require 'rack/ssl'
  
  Rails.application.config.middleware.insert_before(
    ActionDispatch::Cookies,
    Rack::SSL,
    redirect: { exclude: ->(request) { request.path =~ /healthcheck/ } },
    hsts: { expires: 1.year, subdomains: false }
  )
end