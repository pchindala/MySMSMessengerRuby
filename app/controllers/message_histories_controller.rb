class MessageHistoriesController < ApplicationController
  # before_action :current_user
  # GET /message_histories
  def index
    @message_histories = User.first.message_histories.order_by(created_at: :desc)
    render json: @message_histories
  end


  def create
    @message_history = User.first.message_histories.new(message_history_params)
    @message_history.from = ENV['TWILIO_PHONE_NUMBER']
    @message_history.mgs_count = @message_history.message.split("").count
    if @message_history.save
      render json: @message_history, status: :created
    else
      render json: @message_history.errors, status: :unprocessable_entity
    end
  end





  private
    # Only allow a list of trusted parameters through.
    def message_history_params
      params.expect(message_history: [ :user_id, :from, :to, :message,])
    end
end





