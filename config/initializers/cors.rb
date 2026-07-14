# Be sure to restart your server when you modify this file.

# Allow cross-origin requests from the configured web/mobile client origins.
# CORS_ORIGINS is a comma-separated list, e.g. "https://app.example.com,https://staging.example.com".

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch("CORS_ORIGINS", "").split(",").map(&:strip)

    resource "/api/*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
