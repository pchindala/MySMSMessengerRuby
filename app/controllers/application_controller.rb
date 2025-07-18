class ApplicationController < ActionController::API
    include ActionController::Cookies
  include Devise::Controllers::Helpers

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action :debugging
  before_action :valid?,only: [:authenticate!]
  def authenticate!
    token = auth_header.split(' ').last
    payload = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
    user = User.find_by(id: payload['sub'])
    if user.nil? || JwtDenylist.find_by(jti: payload['jti']).present?
     return render(json: { error: 'user not fount or session not found' }, status: :unauthorized)
    else
    current_user
    end
  rescue JWT::DecodeError, Mongoid::Errors::DocumentNotFound
    return render json: { error: 'Unauthorizedsss' }, status: :unauthorized
  end

  private

  def auth_header
    request.headers['Authorization']
  end
  protected
  def debugging
    binding.pry
    Rails.logger.debug "Request: #{request.method} #{request.path}"
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password])
  end

  def decode_jwt
    token = auth_header.split(' ').last
    JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
  rescue JWT::DecodeError
    return render json: { error: 'Unauthorized' }, status: :unauthorized
  end
  
  def current_user
    payload = decode_jwt
    @current_usr = User.find_by(id: payload['sub']) if payload
  rescue Mongoid::Errors::DocumentNotFound
    return render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def encode_jwt(user)
    JWT.encode({ sub: user.id, jti: user.jti,exp: 1.hour.from_now.to_i }, ENV['JWT_SECRET_KEY'], 'HS256') 
  end
end
