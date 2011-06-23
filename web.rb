require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/application')

get '/g/:name/:chr/:pos' do
  key = "#{params[:name]}:#{params[:chr]}"
  snp = ChrSnp.load(key)[params[:pos].to_i]
  snp.first.to_yaml
end

get '/g/:name/:chr/:start_pos/:end_pos' do
  key = "#{params[:name]}:#{params[:chr]}"
  start_pos = params[:start_pos].to_i
  end_pos = params[:end_pos].to_i
  Snp.get key => start_pos..end_pos
end