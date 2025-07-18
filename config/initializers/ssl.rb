
if Rails.env.production?
  Rails.application.config.middleware.insert_before(
    ActionDispatch::Cookies,
    ActionDispatch::SSL,
    redirect: { exclude: ->(request) { request.path =~ /healthcheck/ } },
    hsts: { expires: 1.year, subdomains: false }
  )
end