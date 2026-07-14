S3_ENV_KEYS = %w[S3_ENDPOINT S3_REGION S3_ACCESS_KEY_ID S3_SECRET_ACCESS_KEY S3_AUDIO_BUCKET S3_FORCE_PATH_STYLE].freeze

RSpec.configure do |config|
  config.around(:each, :stub_s3_env) do |example|
    original = ENV.to_hash.slice(*S3_ENV_KEYS)

    ENV["S3_ENDPOINT"] = "http://localhost:9000"
    ENV["S3_REGION"] = "auto"
    ENV["S3_ACCESS_KEY_ID"] = "minioadmin"
    ENV["S3_SECRET_ACCESS_KEY"] = "minioadmin"
    ENV["S3_AUDIO_BUCKET"] = "audio"
    ENV["S3_FORCE_PATH_STYLE"] = "true"

    example.run

    S3_ENV_KEYS.each { |key| ENV[key] = original[key] }
  end
end
