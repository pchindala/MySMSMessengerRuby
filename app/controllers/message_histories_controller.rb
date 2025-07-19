class MessageHistoriesController < ApplicationController
  before_action :authenticate!,only: [:index, :create]

  def index
    @message_histories = MessageHistory.where(user_id: current_user.id).order_by(created_at: :desc)
    render json: @message_histories
  end


  def create

    t = TwilioService.new.send_sms(message_history_params[:to], message_history_params[:message])
    @mh = MessageHistory.new(user_id: current_user.id, from: t.from, to: t.to, message: t.body, mgs_count: t.body.length, twilio_sid: t.sid, message_status: t.status)
    if @mh.save
      render json: @mh, status: :created
    else
      render json: @mh.errors, status: :unprocessable_entity
    end
  end

  def status_update
    puts "message history--------------------------#{params.as_json} is the message_sid "
    message_sid = params[:MessageSid]
    status = params[:MessageStatus]
    message = MessageHistory.find_by(twilio_sid: message_sid)
    if message
      message.update!(message_status: status)

      puts "message history--------------------------#{message.twilio_sid} is the message_sid "
      puts "message history--------------------------#{message.message_status} is the message_status "
      ActionCable.server.broadcast(
        "message_status_#{message.user_id}",
        { sid: message.twilio_sid, status: message.message_status,message_data: message.as_json }
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

end





