class MessageHistory
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user
  field :from, type: String
  field :to, type: String
  field :message, type: String
  field :mgs_count, type: Integer
  field :twilio_sid, type: String
  field :message_status, type: String
  field :message_error, type: String
  # before_save :send_twilio_message
  def send_twilio_message
    binding.pry if Rails.env.development?
    twilio_service = TwilioService.new
    t = twilio_service.send_sms(self.to, self.message)
    self.twilio_sid = t.sid
    self.message_status = t.status
    self.message_error = t.error_code
  rescue StandardError => e
    puts "Error sending SMS: #{e.message}"
    self.message_error = e.message
  end
end
