require 'rubygems'
require 'bundler/setup'

Bundler.require

require File.expand_path(File.dirname(__FILE__) + '/lib/chr_snp')
require File.expand_path(File.dirname(__FILE__) + '/lib/snp')
require File.expand_path(File.dirname(__FILE__) + '/lib/db_snp_importer')



REDIS = Redis.new
