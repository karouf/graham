require 'csv'

module Graham
  class Symbols
    def self.from_exchange(exchange)
      return [] if exchange != 'XNYS'
      CSV.read("lib/graham/symbols/#{exchange}.csv", headers: true, col_sep: "\t").map{ |r| r[0] }
    end
  end
end
