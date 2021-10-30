# frozen_string_literal: true

require 'rails_helper'

describe 'TransactionsController', type: :request do
  before do
    allow_any_instance_of(Tx::BroadcastToBlockchain).to receive(:call).and_return('tx_id')
  end

  context 'when user wants does not send usdt_value' do
    let(:params) do
      {
        exchange_rate: 0.00001,
        address: 'tb1q0v47kzs36at4r43n7m0pukc6zmrftulelz32azlda76avycf6vwqj5wtm2',
        email: 'test@email.com'
      }
    end

    it 'returns error' do
      post(transactions_path, params: { transaction: params })

      expect(response).to render_template(:new)
      expect(assigns(:errors)).to eq({ :usdt_value => ["is missing"] })
    end
  end

  context 'when user wants does not send usdt_value' do
    let(:params) do
      {
        usdt_value: 31,
        exchange_rate: 0.00001,
        address: 'tb1q0v47kzs36at4r43n7m0pukc6zmrftulelz32azlda76avycf6vwqj5wtm2',
        email: 'test@email.com'
      }
    end

    it 'returns error' do
      post(transactions_path, params: { transaction: params })

      expect(response).to render_template(:new)
      expect(assigns(:errors)).to eq({ :usdt_value => ["must be less than 30"] })
    end
  end

  context 'when user sends valid request' do
    let(:params) do
      {
        usdt_value: 22,
        exchange_rate: 0.00001,
        address: 'tb1q0v47kzs36at4r43n7m0pukc6zmrftulelz32azlda76avycf6vwqj5wtm2',
        email: 'test@email.com'
      }
    end

    it 'redirects to show tx' do
      post(transactions_path, params: { transaction: params })

      tx = Transaction.last
      expect(response).to redirect_to(transaction_path(tx.id))
    end
  end
end
