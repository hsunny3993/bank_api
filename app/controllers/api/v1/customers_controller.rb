# frozen_string_literal: true
module Api
  module V1
    class CustomersController < ApplicationController
      before_action :set_customer, only: [:show, :update, :destroy]

      def index
        @customers = Customer.all
        render json: @customers
      end

      def show
        render json: @customer
      end

      def create
        @customer = Customer.create(
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        )

        @account = Account.create(
          account_name: params[:account_name].nil? ? '' : params[:account_name],
          customer_id: @customer.id,
          account_number: Account.generate_account_number
        )

        if @customer && @account
          render json: { id: @customer.id, name: @customer.name, email: @customer.email, phone: @customer.phone, 
                         account_id: @account.id, account_number: @account.account_number, account_name: @account.account_name }
        else
          render json: { error: 'Failed' }, status: 500
        end
      end

      def update
        @customer.update(
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        )
        render json: @customer
      end

      def destroy
        @customer.destroy
        @customers = Customer.all
        render json: @customers
      end

      private

      def set_customer
        @customer = Customer.find(params[:id])
      end
    end
  end
end
