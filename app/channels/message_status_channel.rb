class MessageStatusChannel < ApplicationCable::Channel
  def subscribed
    # Authorize user first
    puts "subscribed to message_status channel for #{params}"
    puts "connection--------------------------#{params[:auth_token]} is the user_id "
    token = params[:auth_token]
    payload =  JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
    puts "payload--------------------------#{payload} is the payload "
    puts "payload--------------------------#{payload['sub']} is the payload sub "
    user = User.find_by(id: payload['sub']) if payload
    reject unless user

    stream_from "message_status_#{user.id}"
  rescue JWT::ExpiredSignature => e
    :expired
  end

  def unsubscribed
    stop_all_streams
  end
end
