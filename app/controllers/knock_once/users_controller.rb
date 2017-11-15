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
      if @user.authenticate(params[:current_password])
        if @user.update(user_params) && @user == current_user
          render json: {
            user: @user,
            message: 'Your profile has been updated!'
          }
        else
          @user.errors.add(:base, :bad_parameter, message: 'There was a problem, please re-enter your data and try again.')
          render json: @user.errors.full_messages, status: :unprocessable_entity
        end
      else
        render status: :unprocessable_entity, json: ['Current password is incorrect']
      end
    end

    def destroy
      @user = current_user
      if @user.destroy
        render json: :success
      else
        render json: @user.errors.full_messages
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
      params.permit(KnockOnce::Configuration.user_params.each { |param| param })
    end
  end
end
