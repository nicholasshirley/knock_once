module KnockOnce
  class PasswordResetMailer < ApplicationMailer
    default from: 'no-reply@your_app_name_here.com'

    def password_reset(user, token)
      @user = user
      @token = token

      mail(
        to: @user.email,
        subject: 'Forgot password request')
    end
  end
end
