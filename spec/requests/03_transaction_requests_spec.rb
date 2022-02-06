require 'rails_helper'

RSpec.describe 'TransactionRequests', type: :request do

  describe 'GET /index' do
    context 'with token' do
      it 'should return http success' do
        user = AuthHelper.authenticated_user
        get '/api/v1/transactions', headers: user[:auth_header]
        expect(response).to have_http_status(200)
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get '/api/v1/transactions'
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /show' do
    it 'returns same attributes' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      json = JSON.parse(response.body).deep_symbolize_keys

      post '/api/v1/accounts/deposit', headers: user[:auth_header], params: {
        id: json[:account_id],
        amount: 50.5
      }

      get '/api/v1/transactions', headers: user[:auth_header]

      expect(response).to have_http_status(200)
      expect(Transaction.count).to eq(1)
    end
  end
end
