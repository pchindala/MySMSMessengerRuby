require "test_helper"

class MessageHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @message_history = message_histories(:one)
  end

  test "should get index" do
    get message_histories_url, as: :json
    assert_response :success
  end

  test "should create message_history" do
    assert_difference("MessageHistory.count") do
      post message_histories_url, params: { message_history: { from: @message_history.from, message: @message_history.message, message_error: @message_history.message_error, message_status: @message_history.message_status, mgs_count: @message_history.mgs_count, status: @message_history.status, time_in_utc: @message_history.time_in_utc, to: @message_history.to, twilio_sid: @message_history.twilio_sid, user_id: @message_history.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show message_history" do
    get message_history_url(@message_history), as: :json
    assert_response :success
  end

  test "should update message_history" do
    patch message_history_url(@message_history), params: { message_history: { from: @message_history.from, message: @message_history.message, message_error: @message_history.message_error, message_status: @message_history.message_status, mgs_count: @message_history.mgs_count, status: @message_history.status, time_in_utc: @message_history.time_in_utc, to: @message_history.to, twilio_sid: @message_history.twilio_sid, user_id: @message_history.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy message_history" do
    assert_difference("MessageHistory.count", -1) do
      delete message_history_url(@message_history), as: :json
    end

    assert_response :no_content
  end
end
