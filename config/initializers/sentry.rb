# Initialize Sentry bug report
Sentry.init do |config|
  config.dsn = Rails.application.credentials.sentry_dsn
  config.breadcrumbs_logger = [:active_support_logger]

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  #config.traces_sample_rate = 0.5
  config.traces_sample_rate = 0.0
end