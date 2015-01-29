require 'json'
require 'nokogiri'

module Graham
  class Morningstar
    def get(stock)
      if @stock != stock
        populate(stock)
      end

      @stock
    end

    private

    def populate(stock)
      @stock = stock
      @stock.price = price
      @stock.price_to_earnings = price_to_earnings
      @stock.price_to_book = price_to_book
      @stock.dividend_yield = dividend_yield
      @stock.earnings_per_share_history = earnings_per_share_history
      @stock.current_ratio = current_ratio
      @stock.market_cap = market_cap
    end

    def price
      header.xpath('//*[@id="last-price-value"]').inner_text.to_f
    end

    def price_to_earnings
      valuation.xpath('//*[@id="currentValuationTable"]/tbody/tr[2]/td[1]').inner_text.to_f
    end

    def price_to_book
      valuation.xpath('//*[@id="currentValuationTable"]/tbody/tr[4]/td[1]').inner_text.to_f
    end

    def dividend_yield
      valuation.xpath('//*[@id="currentValuationTable"]/tbody/tr[10]/td[1]').inner_text.to_f
    end

    def earnings_per_share
      financials.xpath('//*[@id="financials"]/table/tbody/tr[12]').inner_text.to_f
    end

    def earnings_per_share_history
      financials.xpath('//*[@id="financials"]/table/tbody/tr[12]/td').to_a.map(&:inner_text).map{ |i| i == '—' ? nil : i.to_f }
    end

    def current_ratio
        key_stats.xpath('//*[@id="tab-financial"]/table[2]/tbody/tr[2]/td[11]').inner_text.to_f
    end

    def market_cap
      value = header.xpath('//*[@id="MarketCap"]').inner_text
      value = value.to_f * 1_000_000_000 if value.to_s.match(/bil/)
      value = value.to_f * 1_000_000 if value.to_s.match(/mil/)
    end

    def valuation
      Nokogiri::HTML(open(valuation_url))
    end

    def financials
      Nokogiri::HTML(JSON.parse(open(financials_url).read)["componentData"])
    end

    def key_stats
      Nokogiri::HTML(JSON.parse(open(key_stats_url).read)["componentData"])
    end

    def header
      Nokogiri::HTML(open(header_url))
    end

    def valuation_url
      "http://financials.morningstar.com/valuation/current-valuation-list.action?&t=#{@stock.exchange}:#{@stock.symbol}"
    end

    def financials_url
      "http://financials.morningstar.com/financials/getFinancePart.html?&&t=#{@stock.exchange}:#{@stock.symbol}"
    end

    def key_stats_url
      "http://financials.morningstar.com/financials/getKeyStatPart.html?&t=#{@stock.exchange}:#{@stock.symbol}"
    end

    def header_url
      "http://quotes.morningstar.com/stock/c-header?&t=#{@stock.exchange}:#{@stock.symbol}"
    end
  end
end
