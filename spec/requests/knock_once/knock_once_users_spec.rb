require 'rails_helper'

include KnockOnce::Engine.routes.url_helpers

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  describe "GET /knock_once_users" do
    context 'when the user passes no token' do
      it 'returns 401' do
        get users_path(user)
        expect(response).to have_http_status(401)
      end
    end

    context ' when the user passes an invalid token' do
      it 'returns 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the user does have a valid token' do
      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
