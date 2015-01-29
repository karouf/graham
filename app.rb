#!/usr/bin/env ruby

require 'sinatra'
require_relative 'lib/graham'

get '/:exchange/:limit' do
  exchange = params[:exchange]
  limit = params[:limit].to_i

  if limit == 0
    stocks = Graham::Symbols.from_exchange(exchange).shuffle.map{ |i| Graham::Stock.new(exchange, i) }
  else
    stocks = Graham::Symbols.from_exchange(exchange).shuffle.first(limit).map{ |i| Graham::Stock.new(exchange, i) }
  end

  batch_evaluator = Graham::BatchEvaluator.new(stocks)

  batch_evaluator.process

  @stocks = batch_evaluator.positives

  erb :index
end
