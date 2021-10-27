class CalculateTotalValue
  EXCHANGER_FEE_PERCENT = 0.03
  MINE_FEE = 0.000006

  def self.call(value, exchange_rate)
    new(value, exchange_rate).call
  end

  attr_reader :value, :exchange_rate

  def initialize(value, exchange_rate)
    @value = value.to_f
    @exchange_rate = exchange_rate.to_f
  end

  def call
    value * exchange_rate * (1 - EXCHANGER_FEE_PERCENT) - MINE_FEE
  end
end
