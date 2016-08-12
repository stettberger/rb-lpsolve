#!/usr/bin/env ruby
require 'mkmf'
dir_config('lpsolve')
have_library("dl")
have_library("m")
have_library("colamd")
have_library("lpsolve55_pic") || have_library("lpsolve55") ||  missing("lpsolve55")
have_header("lpsolve/lp_lib.h") || have_header("lp_lib.h") || missing("lp_lib.h")
config_file = File.join(File.dirname(__FILE__), 'config_options.rb')
load config_file if File.exist?(config_file)

create_makefile('lpsolve')
