module Graham
  class Stock
    attr_accessor :exchange, :symbol, :name
    attr_accessor :price, :market_cap, :price_to_earnings, :price_to_book,
                  :dividend_yield, :earnings_per_share_history, :current_ratio

    def initialize(exchange, symbol, name = nil)
      self.exchange = exchange
      self.symbol = symbol
      self.name = name
    end
  end
end
