# frozen_string_literal: true

class Transaction < ApplicationRecord
  MINE_FEE = 0.000006

  scope :success, -> { where.not(tx_id: nil) }

  def btc_value
    v = Tx::CalculateTotalValues.new(usdt_value, exchange_rate).call
    v.btc_value
  end

  def status
    return 'success' if tx_id.present?

    'fail'
  end
end
