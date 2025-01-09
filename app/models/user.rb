class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
  validates :name, presence: true,
            length: { maximum: 20 }
  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true,
            length: { minimum: 6 }, allow_nil: true
  # Adds attr_accessor for password and password_confirmation
  has_secure_password

  # returns the hash digest of the given string
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # returns random token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # returns true if token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end
end
