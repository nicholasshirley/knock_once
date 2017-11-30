require 'rails_helper'

include Helpers
include KnockOnce::Engine.routes.url_helpers

RSpec.describe "Passwords", type: :request do
  let(:user) { create(:user) }

  describe 'PATCH /auth/passwords' do
    context 'when the header is valid'
      context 'and password is correct' do
        before { patch passwords_path, params: correct_password, headers: authenticated_header }

        it 'returns the user' do
          user = JSON.parse(response.body)
          expect(user['user']['email']).to eq('newtest@test.com')
        end

        it 'returns 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and password is incorrect' do
        it 'returns 422' do
          patch passwords_path, params: incorrect_password, headers: authenticated_header
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when the header is invalid' do
      context 'and password is correct' do
        it 'returns 401' do
          patch passwords_path, params: correct_password, headers: bad_header
          expect(response).to have_http_status(401)
        end
      end

      context 'and password is incorrect' do
        it 'returns 401' do
          patch passwords_path, params: incorrect_password, headers: bad_header
          expect(response).to have_http_status(401)
        end
      end
    end

  describe 'POST /auth/passwords/reset' do
    context 'when user exists' do
      before { post passwords_reset_path, params: { email: user.email } }
      it 'send reset email' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it 'updates token' do
        expect(user.reload.password_reset_token).not_to be_nil
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user does not exist' do
      before { post passwords_reset_path, params: { email: 'doesntexist@test.com' } }

      it 'does not send reset email' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it 'does not udpate token' do
        expect(user.reload.password_reset_token).to be_nil
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'PATCH /auth/passwords/reset' do
    context 'when the reset tokene exists' do
      context 'and the token is not expired' do
        context 'and the user is successfully updated' do
          # TODO not sure how to implement this. Needs to create a token
          # and save it first, then the patch request will use that token
          # to look up the user and proceed
          it 'returns success' do

          end
        end

        context 'but the user passes a mal-formed password' do

        end

        context 'but the password confirmation does not match' do

        end
      end

      context 'but the token is expired' do

      end
    end

    context 'when the token is not found' do

    end
  end

  describe 'POST /auth/passwords/validate' do
    # TODO not sure how to implement this. Needs to create a token
    # and save it first, then the patch request will use that token
    # to look up the user and proceed
  end
end
