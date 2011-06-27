require 'sinatra'
require File.expand_path(File.dirname(__FILE__) + '/application')

get '/g/:name/:chr/:pos' do
  key = "#{params[:name]}:#{params[:chr]}"
  snp = DbSnpChromossome.load(key)[params[:pos].to_i]
  snp.first.chr_pos
end

get '/g/:name/:chr/:start_pos/:end_pos' do
  ""
end