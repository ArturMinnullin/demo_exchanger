class TransactionsController < ApplicationController
  def new
  end

  def create
    btc_value = CalculateTotalValue.call(tx_params[:usdt_value], tx_params[:exchange_rate])
    paramz = transaction_params.to_h.merge(btc_value: btc_value)
    contract = TransactionContract.new.call(paramz)

    if contract.errors.present?
      @errors = contract.errors.to_h
      render :new
    else
    end
  end

  def show

  end

  private

  def tx_params
    params.require(:transaction).permit(:usdt_value, :exchange_rate, :address, :email)
  end
end
