require_dependency 'knock_once/application_controller'

module KnockOnce
  class UsersController < ApplicationController
    before_action :authenticate_user, except: [:create]
    include ActiveModel::SecurePassword

    def show
      @user = current_user
      render json: @user
    end

    def update
      @user = User.find_by_id(current_user.id)

      case KnockOnce.configuration.require_password_to_change
      when :all
        password_required_change
      else
        save_or_return_error
      end
    end

    def destroy
      @user = current_user
      if @user.authenticate(params[:current_password])
        if @user.destroy
          render json: :success
        else
          render json: @user.errors.full_messages
        end
      else
        render status: :unprocessable_entity, json: ['Current password is incorrect']
      end
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(KnockOnce.configuration.user_params)
    end

    def password_required_change
      if @user.authenticate(params[:current_password])
        save_or_return_error
      else
        render status: :unprocessable_entity, json: ['Current password is incorrect']
      end
    end

    def save_or_return_error
      if @user.update(user_params)
        render json: {
          user: @user,
          message: 'Your profile has been updated!'
        }
      else
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end
  end
end
