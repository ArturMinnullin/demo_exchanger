# frozen_string_literal: true

class TransactionsController < ApplicationController
  def new
    @tx = Transaction.new
    @errors = {}
  end

  def create
    mutator.build

    if mutator.errors.present?
      @errors = mutator.errors

      render :new
    else
      redirect_to transaction_path(@mutator.object.tx_id)
    end
  end

  def show
    @transaction = Transaction.find_by(tx_id: params[:id])
    @mine_fee = Transaction::MINE_FEE
  end

  private

  def mutator
    @mutator ||= TransactionMutator.new(tx_params)
  end

  def tx_params
    params.require(:transaction).permit(:usdt_value, :exchange_rate, :address, :email)
  end
end
