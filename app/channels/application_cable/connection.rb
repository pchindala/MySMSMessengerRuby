module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        puts "connection--------------------------#{request.params[:auth_token]} is the user_id "
         token = request.params[:auth_token]
        payload =  JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' }).first
        puts "payload--------------------------#{payload} is the payload "
        puts "payload--------------------------#{payload['sub']} is the payload sub "
        current_user = User.find_by(id: payload['sub']) if payload
        if verified_user = current_user
          verified_user
        else
          reject_unauthorized_connection
        end
      rescue JWT::ExpiredSignature => e
         :expired
      end
  end
end
