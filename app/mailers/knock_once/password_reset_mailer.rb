module KnockOnce
  class PasswordResetMailer < ApplicationMailer
    default from: 'no-reply@sporkbook.com'

    def reset_password(user, token)
      @user = user
      @token = token

      mail(
        to: @user,
        subject: 'Forgot password request from SporkBook')
    end
  end
end
