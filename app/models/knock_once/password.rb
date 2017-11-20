module KnockOnce
  class Password < ApplicationRecord
    attr_accessor :token
    attr_accessor :user

    def self.reset_password (user)
      save_token_and_expiry(user)
      email_reset(user.email)
    end

    def generate_reset_token
      @token = SecureRandom.urlsafe_base64(KnockOnce.configuration.reset_token_length, false)
    end

    def self.save_token_and_expiry(user)
      @user = user
      generate_reset_token
      User.find_by_email(@user['email']).update_attributes(password_reset_token: @token, password_token_expiry: KnockOnce.configuration.password_token_expiry)
    end

    def email_reset(email)
      PasswordResetMailer.password_reset(@user, @token).deliver_now
    end
  end
end
