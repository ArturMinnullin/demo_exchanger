# frozen_string_literal: true

module Admin
  class TransactionsController < AdminBaseController
    def index
      @txs = Transaction.order(:created_at)
      @successful_tx_count = @txs.success.count
      @total_exchange_fee = @txs.sum(:exchange_fee)
    end
  end
end
