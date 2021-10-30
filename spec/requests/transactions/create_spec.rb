# frozen_string_literal: true

require 'rails_helper'

describe 'TransactionsController', type: :request do
  context 'when user wants does not send usdt_value' do
    let(:params) do
      {
        exchange_rate: 0.00001,
        address: '1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY',
        email: 'test@email.com'
      }
    end

    it 'returns error' do
      post(transactions_path, params: { transaction: params })

      expect(response).to render_template(:new)
      expect(assigns(:errors)).to eq({ :usdt_value => ["must be less than 30"] })
    end
  end

  context 'when user wants does not send usdt_value' do
    let(:params) do
      {
        usdt_value: 31,
        exchange_rate: 0.00001,
        address: '1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY',
        email: 'test@email.com'
      }
    end

    it 'returns error' do
      post(transactions_path, params: { transaction: params })

      expect(response).to render_template(:new)
      expect(assigns(:errors)).to eq({ :usdt_value => ["is missing"] })
    end
  end

  context 'when user sends valid request' do
    let(:params) do
      {
        usdt_value: 22,
        exchange_rate: 0.00001,
        address: '1KFHE7w8BhaENAswwryaoccDb6qcT6DbYY',
        email: 'test@email.com'
      }
    end

    it 'redirects to show tx' do
      post(transactions_path, params: { transaction: params })

      expect(response).to redirect_to(transaction_path('tx_id_123123'))
    end
  end
end
