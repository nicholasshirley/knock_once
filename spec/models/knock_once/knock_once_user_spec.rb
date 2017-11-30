require 'rails_helper'

RSpec.describe "User", type: :model do
  describe 'a user is saved' do
    context 'when the attributes are valid' do
      it 'creates the record' do
        user = User.new(email: 'test@test.com', password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
      end
    end
  end

  describe 'is not saved' do
    context 'when the email is invalid because' do
      it 'is missing completely' do
        user = User.new(password: 'password', password_confirmation: 'password')
        expect(user).to_not be_valid
      end

      it 'is missing a domain' do
        user = User.new(email: 'test', password: 'password', password_confirmation: 'password')
        expect(user).to_not be_valid
      end

      it 'is too long' do
        user = User.new(email: 't' * 256, password: 'password', password_confirmation: 'password')
        expect(user).to_not be_valid
      end

      it 'is an exact duplicate of an already registered email' do
        user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
        second_user = User.new(email: 'test@test.com', password: 'password', password_confirmation: 'password')
        expect(second_user).to_not be_valid
      end

      it 'is a duplicate of an already registered email in a different case' do
        user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
        second_user = User.new(email: 'TeSt@test.com', password: 'password', password_confirmation: 'password')
        expect(second_user).to_not be_valid
      end
    end

    context 'when there is a problem with the password' do
      it 'is missing entirely' do
        user = User.new(email: 'test@test.com')
        expect(user).to_not be_valid
      end

      it 'has a mis-matched confirmation' do
        user = User.new(email: 'test@test.com', password: 'password', password_confirmation: 'notPassword')
        expect(user).to_not be_valid
      end

      it 'is too short' do
        user = User.new(email: 'test@test.com', password: 'pass', password_confirmation: 'pass')
        expect(user).to_not be_valid
      end
    end
  end
end
