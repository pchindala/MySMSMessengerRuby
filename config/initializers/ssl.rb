
if Rails.env.production?
  Rails.application.config.middleware.insert_before(
    0,
    ActionDispatch::SSL,
    redirect: { exclude: ->(request) { request.path =~ /healthcheck/ } },
    hsts: { expires: 1.year, subdomains: false }
  )
end