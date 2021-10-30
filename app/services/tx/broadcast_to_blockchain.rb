module Tx
  class BroadcastToBlockchain
    def initialize(params)
      @params = params
    end

    def call
      "tx_id_123123"
    end
  end
end
