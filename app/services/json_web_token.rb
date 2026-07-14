class JsonWebToken
  ALGORITHM = "HS256".freeze

  class DecodeError < StandardError; end

  def self.encode(payload, expires_in: 24.hours)
    payload = payload.merge(exp: expires_in.from_now.to_i)
    JWT.encode(payload, secret, ALGORITHM)
  end

  def self.decode(token)
    body = JWT.decode(token, secret, true, algorithm: ALGORITHM).first
    ActiveSupport::HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    raise DecodeError, e.message
  end

  def self.secret
    ENV["JWT_SECRET"].presence || Rails.application.secret_key_base
  end
  private_class_method :secret
end
