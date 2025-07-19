class JwtService
attr_reader :expire_time

  public
    def initialize
    @secret_key = ENV['JWT_SECRET_KEY']
    @expire_time = 55.minutes.from_now.to_i
end

  def encode(payload)
    JWT.encode({ sub: payload[:id], jti: payload[:jti], exp: @expire_time }, @secret_key, 'HS256')
  rescue JWT::EncodeError => e
    render json: { error: "JWT Encode Error: #{e.message}" }, status: :unauthorized
  end

  def decode(token)
    JWT.decode(token, @secret_key, true, { algorithm: 'HS256' }).first
  rescue JWT::ExpiredSignature => e
    :expired
  end
end
