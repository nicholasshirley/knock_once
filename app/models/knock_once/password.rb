module KnockOnce
  class Password < ApplicationRecord

    def initialize(user)
      @token = SecureRandom.urlsafe_base64(KnockOnce.configuration.reset_token_length, false)
      @user = user
    end

    def save_token_and_expiry
      User.find_by_email(@user['email']).update_attributes(password_reset_token: @token, password_token_expiry: KnockOnce.configuration.password_token_expiry)
    end

    def email_reset
      PasswordResetMailer.password_reset(@user, @token).deliver_now
    end
  end
end
