require 'open-uri'

module Graham
  class BatchEvaluator
    attr_reader :positives, :negatives, :not_found

    def initialize(stocks, datasource = Graham::Morningstar.new, evaluator = Graham::Evaluator.new)
      @stocks = stocks
      @datasource = datasource
      @evaluator = evaluator
      @positives = []
      @negatives = []
      @not_found = []
    end

    def process
      @stocks.each do |stock|
        begin
          stock = @datasource.get(stock)
        rescue OpenURI::HTTPError
          @not_found << stock
          sleep(2)
          next
        end

        if @evaluator.cheap?(stock)
          @positives << stock
        else
          @negatives << stock
        end

        sleep(2)
      end
    end
  end
end
