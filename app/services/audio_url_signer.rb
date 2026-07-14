require "aws-sdk-s3"

# Generates short-lived, read-only URLs for audio objects in the configured
# S3-compatible object store (MinIO in development, GCS via its S3-compatible
# endpoint in production). Rails never streams the audio bytes itself -- it
# only ever hands back one of these URLs.
class AudioUrlSigner
  DEFAULT_EXPIRY = 5.minutes

  def self.call(object_key, expires_in: DEFAULT_EXPIRY)
    new.call(object_key, expires_in: expires_in)
  end

  def call(object_key, expires_in: DEFAULT_EXPIRY)
    signer = Aws::S3::Presigner.new(client: client)
    signer.presigned_url(
      :get_object,
      bucket: bucket,
      key: object_key,
      expires_in: expires_in.to_i
    )
  end

  private

  def client
    @client ||= Aws::S3::Client.new(
      endpoint: ENV["S3_ENDPOINT"],
      region: ENV.fetch("S3_REGION", "auto"),
      access_key_id: ENV.fetch("S3_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("S3_SECRET_ACCESS_KEY"),
      force_path_style: ActiveModel::Type::Boolean.new.cast(ENV.fetch("S3_FORCE_PATH_STYLE", "false"))
    )
  end

  def bucket
    ENV.fetch("S3_AUDIO_BUCKET")
  end
end
