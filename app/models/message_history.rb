class MessageHistory
  include Mongoid::Document
  include Mongoid::Timestamps
  field :user_id, type: BSON::ObjectId
  field :from, type: String
  field :to, type: String
  field :message, type: String
  field :mgs_count, type: Integer
  field :twilio_sid, type: String
  field :message_status, type: String
  field :message_error, type: String
end
