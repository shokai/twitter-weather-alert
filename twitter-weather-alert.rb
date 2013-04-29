#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler'
Bundler.require

args = ArgsParser.parse ARGV do
  arg :twitter, 'twitter username'
  arg :prefix, 'tweet prefix'
  arg :location, '地域'
  arg :rain, '降水確率のしきい値', :default => 40
  arg :help, 'show help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  STDERR.puts
  STDERR.puts "e.g."
  STDERR.puts "  % #{$0} -twitter shokai -location 藤沢"
  exit 1
end

tw = Tw::Client.new
tw.auth args[:twitter]
weather = WeatherJp.get args[:location]
if weather.today.rain.to_i < args[:rain]
  puts weather.today
else
  tw.tweet "#{args[:prefix]} #{weather.today}".strip
end
