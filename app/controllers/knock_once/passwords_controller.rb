require_dependency "knock_once/application_controller"

module KnockOnce
  class PasswordsController < ApplicationController
    before_action :authenticate_user, except: [:create, :edit, :validate]
    include ActiveModel::SecurePassword

    def create
      @user = User.find_by_email(params[:email])
      # if valid user
      if @user
        # generate a new token and save
        password = Password.new(@user)
        password.email_reset
        password.save_token_and_expiry

        render status: 200, json: {
          message: 'Your request has been received. If we have an email matching that account you will receive link to reset your password.'
        }
      # if invalid user
      else
        render status: 200, json: {
          message: 'Your request has been received. If we have an email matching that account you will receive link to reset your password.'
        }
      end
    end

    def validate
      @token = params[:token]
      @user = User.find_by_password_reset_token(@token)
      if @user && Time.now < @user.password_token_expiry
        render status: 202
      else
        render status: 404, json: { message: 'Looks like something went wrong' }
      end
    end

    def edit
      @token = params[:token]
      @user = User.find_by_password_reset_token(@token)

      if @user && Time.now < @user.password_token_expiry
        if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          render status: 200, json: { message: 'Your password has been updated' }
          # delete token and exiry on successful update
          @user.update(password_reset_token: nil, password_token_expiry: nil)
        else
          render status: :unprocessable_entity, json: @user.errors.full_messages
        end
      else
        render status: :expectation_failed, json: { message: 'Looks like something went wrong' }
      end
    end

    def update
      @user = current_user

      case KnockOnce.configuration.require_password_to_change
      when :all, :password
        password_required_change
      else
        save_or_return_error
      end
    end

    private

    def password_params
      params.permit(:password, :password_confirmation, :current_password, :email, :token)
    end

    def password_required_change
      if @user.authenticate(params[:current_password])
        save_or_return_error
      else
        render status: :unprocessable_entity, json: ['Current password is incorrect']
      end
    end

    def save_or_return_error
      if @user.update(password_params)
        render json: {
          user: @user,
          message: 'Your password has been udpated!'
        }
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end
  end
end
