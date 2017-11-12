class Password < ApplicationRecord
  attr_accessor :token
  attr_accessor :user

  def self.generate_reset_token
    @token = SecureRandom.urlsafe_base64(18, false)
  end

  def self.save_token_and_expiry(user)
    @user = user
    generate_reset_token
    User.find_by_email(@user['email']).update_attributes(password_reset_token: @token, password_token_expiry: 1.hour.from_now)
  end

  def self.email_reset(email)
    PasswordResetMailer.reset_password(@user, @token).deliver_now
  end
end
