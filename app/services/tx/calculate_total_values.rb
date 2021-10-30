# frozen_string_literal: true

# convert usdt value to btc, remove comission of exchanger, remove mine fee
module Tx
  class CalculateTotalValues
    EXCHANGE_FEE_RATIO = 0.03

    attr_reader :amount, :exchange_rate

    def initialize(amount, exchange_rate)
      @amount = amount.to_f
      @exchange_rate = exchange_rate.to_f
    end

    def call
      btc = amount * exchange_rate
      exchange_fee = btc * EXCHANGE_FEE_RATIO
      result_value = btc - exchange_fee - Transaction::MINE_FEE
      return OpenStruct.new(btc_value: 0, exchange_fee: 0) if result_value <= 0

      OpenStruct.new(btc_value: result_value, exchange_fee: exchange_fee)
    end
  end
end
