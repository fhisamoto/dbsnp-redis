require 'rubygems'
require 'bundler/setup'

Bundler.require

require 'ostruct'
APP_CONFIG = OpenStruct.new( :redis => Redis.new )

require File.expand_path(File.dirname(__FILE__) + '/lib/db_snp_chomossome')
require File.expand_path(File.dirname(__FILE__) + '/lib/snp')
require File.expand_path(File.dirname(__FILE__) + '/lib/db_snp_importer')


