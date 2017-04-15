class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum gender: [:female, :male]

  has_many :user_tokens
  has_many :trainings

  def token
    user_token = UserToken.generate self
    user_token.token
  end

  def gender=(val)
    super val
  rescue
    super nil
  end

  def output_api
    as_json(methods: [:token])
  end
end
