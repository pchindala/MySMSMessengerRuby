class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @from = ENV['TWILIO_PHONE_NUMBER']
  end

  # Send SMS
  def send_sms(to, body)
    @client.messages.create(
      from: @from,
      to: to,
      body: body
    )
  end
end