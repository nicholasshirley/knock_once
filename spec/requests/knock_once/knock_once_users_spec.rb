require 'rails_helper'

include Helpers
include KnockOnce::Engine.routes.url_helpers

RSpec.describe "Users", type: :request do
  # See user factory for how email and passwords are incrementing
  # basically though the emails are "test#{n}@test.com"
  # and the passwords are "password#{n}""
  let(:user) { create(:user) }

  # GET
  describe 'GET /auth/users' do
    context 'when the user passes no token' do
      it 'returns 401' do
        get users_path
        expect(response).to have_http_status(401)
      end
    end

    context ' when the user passes an invalid token' do
      it 'returns 401' do
        get users_path, headers: bad_header
        expect(response).to have_http_status(401)
      end
    end

    context 'when the user does have a valid token' do
      it 'returns 200' do
        get users_path, headers: authenticated_header
        expect(response).to have_http_status(200)
      end
    end
  end

  # PATCH
  describe 'PATCH /auth/users' do
    # Send with no token
    context 'when the user passes no token' do
      it 'returns 404' do
        patch users_path, params: { email: 'newtest@test.com' }
        expect(response).to have_http_status(401)
      end
    end

    # Send with invalid token
    context 'when the user passes an invalid token' do
      context 'and correct password' do
        it 'returns 401' do
          patch users_path, params: correct_password, headers: bad_header
          expect(response).to have_http_status(401)
        end
      end

      context 'and incorrect password' do
        it 'returns 401' do
          patch users_path, params: incorrect_password, headers: bad_header
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when the user passes a valid token' do
      context 'and correct password' do
        it 'return 200' do
          patch users_path, params: { email: 'newtest@test.com', current_password: user.password }, headers: authenticated_header
          expect(response).to have_http_status(200)
        end

        context 'and incorrect password' do
          it 'returns 422' do
            patch users_path, params: { email: 'newtest@test.com', current_password: 'RandomPassword' }, headers: authenticated_header
            expect(response).to have_http_status(422)
          end
        end
      end
    end
  end

  # DESTROY
  describe 'DELETE /auth/users' do

    # Send with no token
    context 'when the user passes no token' do
      it 'return 401' do
        delete users_path
        expect(response).to have_http_status(401)
      end
    end

    # Send with invalid token
    context 'when the user passes an invalid token' do
      context 'and correct password' do
        it 'return 401' do
          delete users_path, params: { current_password: user.password }, headers: { 'Authorization': 'Bearer AABBCC' }
          expect(response).to have_http_status(401)
        end
      end

      context 'and incorrect password' do
        it 'returns 401' do
          delete users_path, params: { current_password: 'RandomPassword' }, headers: { 'Authorization': 'Bearer AABBCC' }
          expect(response).to have_http_status(401)
        end
      end
    end

    # Send with valid token
    context 'when the user passes a valid token' do
      context 'and correct password' do
        it 'returns 200' do
          delete users_path, params: { current_password: user.password }, headers: authenticated_header
          expect(response).to have_http_status(200)
        end
      end

      context 'and incorrect password' do
        it 'return 422' do
          delete users_path, params: { current_password: 'RandomPassword' }, headers: authenticated_header
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  # CREATE
  describe 'POST to /auth/users' do
    context 'when the body is valid' do
      it 'returns 200' do
        post users_path, params: { email: 'anotherTestEmail@test.com', password: 'password', password_confirmation: 'password' }
        expect(response).to have_http_status(200)
      end
    end

    context 'whent the body is invalid' do
      it 'return 422' do
        post users_path, params: { clowns: 'bozo', password: 'password', password_confirmation: 'notPassword' }
        expect(response).to have_http_status(422)
      end
    end
  end
end
