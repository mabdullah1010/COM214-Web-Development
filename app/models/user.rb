class User < ApplicationRecord
  attr_accessor :remember_token

  has_many :documents, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: true, length: { minimum: 7, maximum: 30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX }, length: { maximum: 250 }
  has_secure_password
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def details
    "Joined on #{self.created_at.strftime("%m/%d/%Y at %H:%M")}"
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column(:remember_digest, nil)
  end
end
