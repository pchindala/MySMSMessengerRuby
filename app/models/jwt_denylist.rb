class JwtDenylist
  include Mongoid::Document
  include Mongoid::Timestamps
  field :jti, type: String
  field :exp, type: DateTime
  index({ exp: 1 }, { expire_after_seconds: 0 })
  

  index({ jti: 1 }, { unique: true })
  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true


  def self.revoked?(jti)
    exists?(jti: jti)
  end
end