# frozen_string_literal: true

class Users::SessionsController < ApplicationController

  def create
    resource = User.find_by(email: sign_in_params[:email])
    if resource.nil? || !resource.valid_password?(sign_in_params[:password])
      return render json: { status: 401, message: 'Invalid email or password' }, status: :unauthorized
    end

    @jti = JwtDenylist.create(jti: SecureRandom.uuid, exp: JwtService.new.expire_time, user_id: resource.id)
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: { 
        user: resource,
        token: JwtService.new.encode({ id: @jti.user_id, jti: @jti.jti })
      }
    }
  rescue error => e
    render json: { error: "error in sign in: #{e.message} " }, status: :unauthorized
  end


  def destroy
    payload = JwtService.new.decode(auth_token)
    user = User.find_by(id: payload['sub']) if payload
    @jti = JwtDenylist.find_by(jti: payload['jti']) if user
    if @jti.active
      render json: { status: 401, message: "Couldn't find active session" }, status: :unauthorized
      else
        @jti.update(active: true)
      render json: { status: 200, message: 'Logged out successfully' }
    end
  rescue StandardError
    render json: { error: "destroy Couldn't find active session" }, status: :unauthorized
  end

  private
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end
