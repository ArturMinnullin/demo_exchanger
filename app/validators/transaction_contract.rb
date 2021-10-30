# frozen_string_literal: true

require 'bitcoin'

class TransactionContract < Dry::Validation::Contract
  params do
    required(:usdt_value).filled.value(:float)
    required(:exchange_rate).filled.value(:float)
    required(:address).filled.value(:string)
    required(:email).filled.value(:string)
    required(:exchange_fee).filled.value(:float)
  end

  rule(:usdt_value) do
    key.failure('must be less than 30') if value >= 30
  end

  rule(:email) do
    key.failure('has invalid format') unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
  end

  rule(:address) do
    key.failure('has invalid format') unless Bitcoin.valid_address?(value)
  end
end
