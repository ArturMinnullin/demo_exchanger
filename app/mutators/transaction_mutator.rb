# frozen_string_literal: true

class TransactionMutator
  attr_reader :params, :errors, :object

  def initialize(params)
    @params = params
    @errors = {}
    @object = Transaction.new(params)
  end

  def build
    contract = TransactionContract.new.call(attributes.to_h)
    if contract.errors.present?
      @errors = contract.errors.to_h
      return
    end

    tx_id = Tx::BroadcastToBlockchain.new(total.btc_value, params[:address]).call
    create_in_db(contract.to_h.merge(tx_id: tx_id))
  end

  private

  def create_in_db(attr)
    tx = Transaction.new(attr)
    tx.save

    @errors = tx.errors
    @object = tx
  end

  def attributes
    params.merge(exchange_fee: total.exchange_fee)
  end

  def total
    # it would be better to refetch exchange_rate here from API
    @total ||= Tx::CalculateTotalValues.new(params[:usdt_value], params[:exchange_rate]).call
  end
end
