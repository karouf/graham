module Graham
  class Evaluator
    MAX_PRICE_TO_EARNINGS = 15
    MAX_PRICE_TO_BOOK = 1.5
    MIN_DIVIDEND_YIELD = 2
    MIN_GROWTH_RATE = 1.33
    MIN_CURRENT_RATIO = 2
    MIN_MARKET_CAP = 150_000_000

    def cheap?(stock)
      evaluate_price_to_earnings(stock) &&
      evaluate_price_to_book(stock) &&
      evaluate_dividend_yield(stock) &&
      evaluate_dividend_history(stock) &&
      evaluate_growth(stock) &&
      evaluate_current_ratio(stock) &&
      evaluate_total_ratio(stock) &&
      evaluate_market_cap(stock)
    end

    private

    def evaluate_price_to_earnings(stock)
      stock.price_to_earnings < MAX_PRICE_TO_EARNINGS
    end

    def evaluate_price_to_book(stock)
      stock.price_to_book < MAX_PRICE_TO_BOOK
    end

    def evaluate_dividend_yield(stock)
      stock.dividend_yield > MIN_DIVIDEND_YIELD
    end

    def evaluate_dividend_history(stock)
    end

    def evaluate_growth(stock)
      start_sample = stock.earnings_per_share_history.last(10).first(3)
      end_sample = stock.earnings_per_share_history.last(3)
      start_avg = start_sample.select{ |i| !i.nil? }.inject(&:+) / start_sample.select{ |i| !i.nil? }.count
      end_avg = end_sample.select{ |i| !i.nil? }.inject(&:+) / end_sample.select{ |i| !i.nil? }.count
      growth_rate = end_sample / start_sample
      growth_rate > MIN_GROWTH_RATE
    end

    def evaluate_current_ratio(stock)
      stock.current_ratio > MIN_CURRENT_RATIO
    end

    def evaluate_total_ratio(stock)
    end

    def evaluate_market_cap(stock)
      stock.market_cap > MIN_MARKET_CAP
    end
  end
end
