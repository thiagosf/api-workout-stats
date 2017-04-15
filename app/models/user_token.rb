class UserToken < ApplicationRecord
  MAX_TIME = 48.hours

  belongs_to :user

  scope :expireds, -> (user) {
    where('expires <= ?', Time.zone.now)
    .where(user_id: user.id)
  }

  scope :no_expired, -> (user) {
    where('expires > ?', Time.zone.now)
    .where(user_id: user.id)
  }

  def self.generate(user)
    valid_token = self.get_valid_token user
    if valid_token.nil?
      remove_expired_tokens user
      token = self.generate_token
      expires = Time.zone.now + MAX_TIME
      valid_token = self.create user: user, token: token, expires: expires
    end
    valid_token
  end

  def self.generate_token
    SecureRandom.uuid
  end

  def self.get_user_by_token(token)
    user_token = includes(:user).where(token: token).first
    unless user_token.nil?
      unless user_token.expired?
        user_token.user
      else
        raise I18n.t('user_tokens.auth.errors.expired')
      end
    else
      raise I18n.t('user_tokens.auth.errors.invalid')
    end
  end

  def expired?
    self.expires <= Time.now
  end

  def self.remove_expired_tokens(user)
    expireds(user).delete_all
  end

  def self.remove_token(token)
    UserToken.where(token: token).delete_all
  end

  def self.get_valid_token(user)
    UserToken.no_expired(user).first
  end
end
