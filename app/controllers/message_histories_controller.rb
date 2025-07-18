class MessageHistoriesController < ApplicationController
  before_action :authenticate!,only: [:index, :create]
  # before_action :validate_twilio_request, only: [:status_update]
  # before_action :current_user
  # GET /message_histories
  def index
    @message_histories = current_user.message_histories.order_by(created_at: :desc)
    render json: @message_histories
  end


  def create
    @message_history = current_user.message_histories.new(message_history_params)
    @message_history.from = ENV['TWILIO_PHONE_NUMBER']
    @message_history.mgs_count = @message_history.message.split("").count
    @message_history.twilio_sid = random_uuid = SecureRandom.uuid if Rails.env.development?
    if @message_history.save
      render json: @message_history, status: :created
    else
      render json: @message_history.errors, status: :unprocessable_entity
    end
  end

  def status_update
    message_sid = params[:MessageSid]
    status = params[:MessageStatus]
    # Find and update message history
    message = MessageHistory.find_by(twilio_sid: message_sid)
    if message
      message.update!(message_status: status)

      puts "message history--------------------------#{message.twilio_sid} is the message_sid "
      puts "message history--------------------------#{message.message_status} is the message_status "
      ActionCable.server.broadcast(
        "message_status_#{message.user_id}",
        { sid: message.twilio_sid, status: message.message_status }
      )
      head :ok
    else
      head :not_found
    end
  end





  private

  def message_history_params
    params.require(:message_history).permit(:to, :message)
  end


    def validate_twilio_request
      validator = Twilio::Security::RequestValidator.new(
        ENV['TWILIO_AUTH_TOKEN']
      )

    signature = request.headers['HTTP_X_TWILIO_SIGNATURE']
    url = request.original_url
    params = request.request_parameters

    unless validator.validate(url, params, signature)
      render plain: 'Invalid signature', status: :forbidden
    end
  end
end





