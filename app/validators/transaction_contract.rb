# frozen_string_literal: true

class TransactionContract < Dry::Validation::Contract
  params do
    required(:usdt_value).filled(:float)
    required(:btc_value).filled(:float)
    required(:address).filled(:string)
    required(:email).filled(:string)
  end

  rule(:email) do
    key.failure('has invalid format') unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
  end

  rule(:btc_value) do
    key.failure('must be less than 30') if value >= 30
  end

  rule(:address) do
    key.failure('has invalid format') unless /^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$/i.match?(value)
  end
end
