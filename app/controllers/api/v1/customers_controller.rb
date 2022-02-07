# frozen_string_literal: true
module Api
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :update, :destroy]

      def_param_group :customer_id do
        param :id, String, required: true, desc: 'id of the requested customer'
      end

      def_param_group :create_customer_params do
        param :name, String, required: true, desc: 'customer name'
        param :email, String, required: true, desc: 'customer email'
        param :phone, String, required: true, desc: 'customer phone'
        param :account_name, String, required: false, desc: 'account name for customer'
      end

      def_param_group :update_customer_params do
        param :name, String, required: true, desc: 'customer name'
        param :email, String, required: true, desc: 'customer email'
        param :phone, String, required: true, desc: 'customer phone'
        param :account_name, String, required: false, desc: 'account name for customer'
      end

      api :GET, '/api/v1/customers', 'Get customers list'
      def index
        @customers = Customer.all
        render json: @customers
      end

      api :GET, '/api/v1/customers/:id', 'Get a customer'
      param_group :customer_id
      def show
        render json: @customer
      end

      api :POST, '/api/v1/customers', 'Create a customer'
      param_group :create_customer_params
      def create
        @customer = Customer.new(customer_params)
        if @customer.save
          @account = Account.new(account_params)
          if @account.save
            render json: { id: @customer.id, name: @customer.name, email: @customer.email, phone: @customer.phone,
                           account_id: @account.id, account_number: @account.account_number,
                           account_name: @account.account_name }, status: :created
          else
            render json: @account.errors, status: :unprocessable_entity
          end
        else
          render json: @customer.errors, status: :unprocessable_entity
        end
      end

      api :PUT, '/api/v1/customers/:id', 'Update a customer'
      param_group :update_customer_params
      def update
        @customer.update(
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        )
        render json: @customer
      end

      api :DELETE, '/api/v1/customers/:id', 'Delete a customer'
      param_group :customer_id
      def destroy
        @account = Account.find_by_customer_id(@customer.id)
        @account.destroy
        @customer.destroy
        @customers = Customer.all
        render json: @customers
      end

      private

      def set_customer
        @customer = Customer.find(params[:id])
      end

      def customer_params
        {
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        }
      end

      def account_params
        {
          account_name: params[:account_name].nil? ? '' : params[:account_name],
          customer_id: @customer.id,
          account_number: Account.generate_account_number
        }
      end
    end
  end
end
