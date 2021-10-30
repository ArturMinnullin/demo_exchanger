# frozen_string_literal: true

class TransactionMutator
  attr_reader :params, :errors, :object

  def initialize(params)
    @params = params
    @errors = {}
    @object = nil
  end

  def build
    tx_id = create_tx_in_blockhain

    contract = TransactionContract.new.call(attributes)
    if contract.errors.present?
      @errors = contract.errors
      return
    end

    create_in_db(tx_id)
  end

  private

  def create_tx_in_blockhain
    Tx::BroadcastToBlockchain.new(params).call
  end

  def create_in_db(tx_id)
    tx = Transaction.new(contract.to_h.merge(tx_id: tx_id))
    tx.save

    @errors = tx.errors
    @object = tx
  end

  def attributes
    total = Tx::CalculateTotalValues.new(params[:usdt_value], params[:exchange_rate]).call

    params.merge(btc_value: total.btc_value, exchange_fee: total.exchange_fee)
  end
end
