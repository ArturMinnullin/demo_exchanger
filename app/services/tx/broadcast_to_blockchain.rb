# frozen_string_literal: true

module Tx
  class BroadcastToBlockchain
    attr_reader :amount

    def initialize(amount, address)
      @amount = amount
    end

    def call

    end

    private

    def build_tx_with_fee(to:, amount:, inputs:, key:, fee: FEE)
      new_tx = build_tx do |t|
        inputs.each do |input|
          t.input do |i|
            i.prev_out input.obj
            i.prev_out_index input.index
            i.signature_key key
          end
        end

        t.output do |o|
          o.value amount * SATOSHIS_PER_BITCOIN
          o.script { |s| s.recipient to }
        end

        unspents_total = inputs.sum(&:amount) / SATOSHIS_PER_BITCOIN
        change = unspents_total - (amount + fee)
        if change > 0
          t.output do |o|
            o.value change * SATOSHIS_PER_BITCOIN
            o.script { |s| s.recipient address }
          end
        end
      end
    end
  end
end
