class TransactionsController < ApplicationController
  def new
    @tx = Transaction.new
    @errors = {}
  end

  # Here we need to call exchange rate again to be more precise but I'm lazy
  def create
    btc_value = CalculateTotalValue.call(tx_params[:usdt_value], tx_params[:exchange_rate])
    paramz = tx_params.to_h.merge(btc_value: btc_value)

    contract = TransactionContract.new.call(paramz)
    render_errors(contract.errors) and return

    @tx = Transaction.new(contract.to_h)
    @tx.save
    render_errors(@tx.errors) and return

    redirect_to transaction_path(@tx.uid)
  end

  def show
    @transaction = Transaction.find_by(uid: params[:id])
    @mine_fee = Transaction::MINE_FEE
  end

  private

  def render_errors(errors)
    return if errors.blank?

    @errors = errors
    render :new
  end

  def tx_params
    params.require(:transaction).permit(:usdt_value, :exchange_rate, :address, :email)
  end
end
