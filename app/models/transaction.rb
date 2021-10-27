class Transaction < ApplicationRecord
  EXCHANGE_FEE_RATIO = 0.03
  MINE_FEE = 0.000006

  after_initialize :generate_uuid

  def exhange_fee
    EXCHANGE_FEE_RATIO * (btc_value + MINE_FEE) / (1 - EXCHANGE_FEE_RATIO)
  end

  private

  def generate_uuid
    self.uid = SecureRandom.uuid if self.uid.blank?
  end
end
