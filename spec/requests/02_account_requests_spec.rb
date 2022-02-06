require 'rails_helper'

RSpec.describe 'AccountRequests', type: :request do

  describe 'GET /show' do
    context 'with token' do
      it 'should return http success' do
        user = AuthHelper.authenticated_user
        post '/api/v1/customers', headers: user[:auth_header], params: {
          name: 'Customer',
          email: 'customer@gmail.com',
          phone: '123123123'
        }
        json = JSON.parse(response.body).deep_symbolize_keys

        get "/api/v1/accounts/#{json[:account_id]}", headers: user[:auth_header]
        expect(response).to have_http_status(200)
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get balance_api_v1_accounts_path
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /balance' do
    it 'returns balance' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      json = JSON.parse(response.body).deep_symbolize_keys

      get '/api/v1/accounts/balance', headers: user[:auth_header], params: { id: json[:account_id] }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:balance].to_f).to eq(0.0)
    end
  end

  describe 'POST /deposit' do
    it 'returns deposited amount' do
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
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:account_balance].to_f).to eq(50.5)
    end
  end

  describe 'POST /withdraw' do
    it 'returns withdrawed amount' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      json = JSON.parse(response.body).deep_symbolize_keys

      post '/api/v1/accounts/withdraw', headers: user[:auth_header], params: {
        id: json[:account_id],
        amount: 50.5
      }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:account_balance].to_f).to eq(-50.5)
    end
  end

  describe 'POST /transfer' do
    it 'returns relative accounts' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer1',
        email: 'customer1@gmail.com',
        phone: '123123123'
      }
      customer1 = JSON.parse(response.body).deep_symbolize_keys

      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer2',
        email: 'customer2@gmail.com',
        phone: '1231231234'
      }
      customer2 = JSON.parse(response.body).deep_symbolize_keys

      post '/api/v1/accounts/transfer', headers: user[:auth_header], params: {
        from_account_id: customer1[:account_id],
        to_account_id: customer2[:account_id],
        amount: 50.5
      }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:from][:account_balance].to_f).to eq(-50.5)
      expect(json[:to][:account_balance].to_f).to eq(50.5)
    end
  end
end
