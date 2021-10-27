class CalculateTotalValue
  def self.call(value, exchange_rate)
    new(value, exchange_rate).call
  end

  attr_reader :value, :exchange_rate

  def initialize(value, exchange_rate)
    @value = value.to_f
    @exchange_rate = exchange_rate.to_f
  end

  def call
    # convert usdt value to btc, remove comission of exchanger, remove mine fee
    result = value * exchange_rate * (1 - Transaction::EXCHANGE_FEE_RATIO) - Transaction::MINE_FEE
    return 0 if result <= 0

    result
  end
end
