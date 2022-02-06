module Api
  module V1
    class AccountsController < ApplicationController
      before_action :set_account, only: [:balance, :show, :deposit, :withdraw]

      def show
        render json: @account
      end

      def balance
        render json: { balance: @account[:account_balance] }
      end

      def deposit
        @account = Account.credit(@account.account_number, params[:amount].to_f)
        @customer = Customer.find(@account.customer_id)

        # Add a transaction
        @customer.transactions.create(
          account_id: @account.id,
          debit_credit_flag: false,   # credit
          amount: params[:amount].to_f,
          transaction_date: DateTime.now
        )

        render json: @account
      end

      def withdraw
        @account = Account.debit(@account.account_number, params[:amount].to_f)
        @customer = Customer.find(@account.customer_id)

        # Add a transaction
        @customer.transactions.create(
          account_id: @account.id,
          debit_credit_flag: true,    # debit
          amount: params[:amount].to_f,
          transaction_date: DateTime.now
        )

        render json: @account
      end

      def transfer
        now = DateTime.now
        from_account = Account.find(params[:from_account_id])
        from_account = Account.debit(from_account.account_number, params[:amount].to_f)

        to_account = Account.find(params[:to_account_id])
        to_account = Account.credit(to_account.account_number, params[:amount].to_f)

        # Add transactions
        Transaction.create(
          customer_id: from_account.customer_id,
          account_id: from_account.id,
          debit_credit_flag: true,    # debit
          amount: params[:amount].to_f,
          transaction_date: now
        )

        Transaction.create(
          customer_id: to_account.customer_id,
          account_id: from_account.id,
          debit_credit_flag: false,   # credit
          amount: params[:amount].to_f,
          transaction_date: now
        )

        render json: { from: from_account, to: to_account }
      end

      private

      def set_account
        @account = Account.find(params[:id])
      end
    end
  end
end
