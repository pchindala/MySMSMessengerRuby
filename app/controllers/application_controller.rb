class ApplicationController < ActionController::API


  def authenticate!
    user = current_user_jti[:user]
    if user.nil? || JwtDenylist.find_by(jti: current_user_jti[:jti], user_id: user.id, active: true).present?
      render(json: { error: 'session not found or session not found' }, status: :unauthorized)
    end
  rescue error => e
    puts "Authentication error: #{e.message}"
    render json: { error: 'session expired Unauthorizedsss' }, status: :unauthorized
  end

  private

  def auth_token
    request.headers['Authorization'].split(' ').last
  rescue error
    render json: { error: 'Authorization header not found' }, status: :unauthorized
  end

  
  def current_user_jti
    payload = JwtService.new.decode(auth_token)
    {user: User.find_by(id: payload['sub']),jti: payload['jti']} if payload
  rescue error  => e
    puts "Error decoding JWT: #{e.message}"
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
  def current_user
    current_user_jti[:user]
  end
end

