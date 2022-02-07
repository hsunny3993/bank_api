# frozen_string_literal: true
module Api
  module V1
    class TransactionsController < ApplicationController
      def_param_group :transaction_id do
        param :id, String, required: true, desc: 'id of the requested transaction'
      end

      api :GET, '/api/v1/transactions', 'Get transactions list'
      def index
        @transactions = Transaction.all
        render json: @transactions
      end

      api :GET, '/api/v1/transactions/:id', 'Get transaction detail'
      param_group :transaction_id
      def show
        @transaction = Transaction.find(params[:id])
        render json: @transaction
      end
    end
  end
end
