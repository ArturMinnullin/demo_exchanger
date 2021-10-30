# frozen_string_literal: true

class TransactionMutator
  attr_reader :params, :errors, :object

  def initialize(params)
    @params = params
    @errors = {}
    @object = Transaction.new(params)
  end

  def build
    tx_id = create_tx_in_blockhain

    contract = TransactionContract.new.call(attributes.to_h)
    if contract.errors.present?
      @errors = contract.errors.to_h
      return
    end

    create_in_db(contract.to_h.merge(tx_id: tx_id))
  end

  private

  def create_tx_in_blockhain
    "tx_id"
    # Tx::BroadcastToBlockchain.new(params).call
  end

  def create_in_db(attr)
    tx = Transaction.new(attr)
    tx.save

    @errors = tx.errors
    @object = tx
  end

  def attributes
    binding.pry
    total = Tx::CalculateTotalValues.new(params[:usdt_value], exchange_rate).call
    params.merge(btc_value: total.btc_value, exchange_fee: total.exchange_fee)
  end

  def exchange_rate
    @exchange_rate ||= begin
      res = Net::HTTP.get_response(URI('https://api.exchangerate.host/latest?base=USD&symbols=BTC'))
      JSON.parse(res.body).dig('rates', 'BTC') || params[:exchange_rate]
    end
  end
end
