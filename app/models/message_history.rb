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

  def send_twilio_message
    twilio_service = TwilioService.new
    twilio_service.send_sms(self.to, self.message)
  rescue StandardError => e
    self.message_error = e.message
    self.save
  end
end
