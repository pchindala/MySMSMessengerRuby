class JwtDenylist
  include Mongoid::Document
  include Mongoid::Timestamps
  field :jti, type: String
  field :exp, type: DateTime
  field :user_id, type: BSON::ObjectId
  field :active, type: Boolean, default: false
  index({ jti: 1 }, { unique: true })
  index({ exp: 1 }, { expire_after_seconds: 0 })
  belongs_to :user
  before_create :assign_jti
  before_save :assign_jti

  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true


  def self.revoked?(jti)
    exists?(jti: jti)
  end

  private
  def assign_jti
    self.jti = SecureRandom.uuid if jti.blank?
  end
end