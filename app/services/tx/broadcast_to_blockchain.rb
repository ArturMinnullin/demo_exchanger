# frozen_string_literal: true

require 'bitcoin'
require 'net/http';
require 'json';

module Tx
  class BroadcastToBlockchain
    ESPLORA_API_BASE = 'https://blockstream.info/testnet/api'
    SATOSHIS_PER_BITCOIN = 100_000_000.0

    include Bitcoin::Builder

    attr_reader :amount

    def initialize(amount, address)
      @amount = amount
      @address = address
    end

    def call
      raise 'Error: balance is lower than transaction value' if inputs.sum(&:amount) < amount

      tx = build_tx_with_fee
      req = Net::HTTP.post(
        URI("#{ESPLORA_API_BASE}/tx"), new_tx.payload.unpack("H*").first, 'Content-Type' => 'application/json'
      )
      return unless res.is_a?(Net::HTTPSuccess)

      req.body.hash
    end

    private

    def build_tx_with_fee
      new_tx = build_tx do |t|
        inputs.each do |input|
          t.input do |i|
            i.prev_out input.obj
            i.prev_out_index input.index
            i.signature_key key
          end
        end

        t.output do |o|
          o.value (amount - Transaction::MINE_FEE) * SATOSHIS_PER_BITCOIN
          o.script { |s| s.recipient to }
        end

        unspents_total = inputs.sum(&:amount) / SATOSHIS_PER_BITCOIN
        change = unspents_total - amount
        if change > 0
          t.output do |o|
            o.value change * SATOSHIS_PER_BITCOIN
            o.script { |s| s.recipient address }
          end
        end
      end
    end

    def key
      @key ||= Bitcoin::Key.new(Rails.application.credentials[:exchange_private_key])
    end

    def inputs
      @inputs ||= unspent_tx_list.map do |t|
        tx = get_binary_by_id(t['txid'])
        OpenStruct.new(obj: Bitcoin::P::Tx.new(tx), index: t['vout'], amount: t['value'])
      end
    end

    def unspent_tx_list
      res = Net::HTTP.get_response(URI("#{ESPLORA_API_BASE}/address/#{key.address}/utxo"))
      raise "Can't fetch utxo" unless res.is_a?(Net::HTTPSuccess)

      JSON.parse(res.body)
    end

    def get_binary_by_id(id)
      res = Net::HTTP.get_response(URI("#{ESPLORA_API_BASE}/tx/#{id}/raw"))
      res.body
    end
  end
end
