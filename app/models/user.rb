require 'byebug'
class User < ActiveRecord::Base

  attr_reader :password

  has_many(
    :cats,
    foreign_key: :user_id,
    class_name: "Cat"
  )

  has_many(
    :cat_rental_requests,
    foreign_key: :user_id,
    class_name: "CatRentalRequest"
  )

  validates :user_name, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  validates :session_token, presence: true
  after_initialize :ensure_session_token

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

end
