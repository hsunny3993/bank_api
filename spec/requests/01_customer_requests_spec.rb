require 'rails_helper'

RSpec.describe 'CustomerRequests', type: :request do

  describe 'GET /index' do
    context 'with token' do
      it 'should return http success' do
        user = AuthHelper.authenticated_user
        get '/api/v1/customers', headers: user[:auth_header]
        expect(response).to have_http_status(200)
      end
    end

    context 'without token' do
      it 'returns unauthorized' do
        get '/api/v1/customers'
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

      get "/api/v1/customers/#{json[:id]}", headers: user[:auth_header]
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq('Customer')
      expect(json[:email]).to eq('customer@gmail.com')
      expect(json[:phone]).to eq('123123123')
      expect(Customer.count).to eq(1)
    end
  end

  describe 'POST /create' do
    it 'valid customer attributes' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      expect(response.status).to eq(201)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq('Customer')
      expect(json[:email]).to eq('customer@gmail.com')
      expect(json[:phone]).to eq('123123123')
      expect(Customer.count).to eq(1)
    end

    it 'invalid customer attributes with empty email and duplicated phone number' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: '',
        phone: '123123123'
      }

      expect(response.status).to eq(422)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:email]).to eq(["can't be blank"])
      expect(Customer.count).to eq(0)
    end
  end

  describe 'PATCH /update' do
    it 'returns with passed params' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      json = JSON.parse(response.body).deep_symbolize_keys

      put "/api/v1/customers/#{json[:id]}", headers: user[:auth_header], params: {
        name: 'Customer1',
        email: 'customer1@gmail.com',
        phone: '1231231234'
      }
      expect(response.status).to eq(200)

      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:name]).to eq('Customer1')
      expect(json[:email]).to eq('customer1@gmail.com')
      expect(json[:phone]).to eq('1231231234')
      expect(Customer.count).to eq(1)
    end
  end

  describe 'DELETE /destroy' do
    it 'delete a customer' do
      user = AuthHelper.authenticated_user
      post '/api/v1/customers', headers: user[:auth_header], params: {
        name: 'Customer',
        email: 'customer@gmail.com',
        phone: '123123123'
      }
      json = JSON.parse(response.body).deep_symbolize_keys

      delete "/api/v1/customers/#{json[:id]}", headers: user[:auth_header]
      expect(response.status).to eq(200)
      expect(Customer.count).to eq(0)
    end
  end
end
