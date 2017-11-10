module KnockOnce
  class UserMailer < ApplicationMailer
    def welcome_mailer(user)
      @user = user
      mail(to: @user.email,
           subject: 'Welcome to Sporkbook!') do |format|
             format.html { render 'welcome_mailer' }
             format.text { render 'welcome_mailer' }
           end
    end
  end
end
