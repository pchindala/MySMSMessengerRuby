# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    token = auth_header.split(' ').last
    payload = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
    user = User.find_by(id: payload['sub'])
    @jti = JwtDenylist.find_by(jti: user.jti) if user
    unless @jti.nil?
      render json: { status: 401, message: "Couldn't find active session" }, status: :unauthorized
      else
        JwtDenylist.create(jti: user.jti, exp:  Time.at(payload['exp'])) if user
      render json: { status: 200, message: 'Logged out successfully' }
    end
  rescue JWT::DecodeError, Mongoid::Errors::DocumentNotFound
    render json: { error: "Couldn't find active session" }, status: :unauthorized
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    resource = User.find_by(email: sign_in_params[:email])
    if resource.nil? || !resource.valid_password?(sign_in_params[:password])
      return render json: { status: 401, message: 'Invalid email or password' }, status: :unauthorized
    end
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: { 
        user: resource,
        token: resource.generate_jwt,
      }
    }
  end


  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
  def auth_header
    request.headers['Authorization']
  end
end
