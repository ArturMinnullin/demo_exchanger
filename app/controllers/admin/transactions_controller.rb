module Admin
  class TransactionsController < AdminBaseController
    def index
      @transactions = Transaction.order(:created_at)
    end
  end
end
