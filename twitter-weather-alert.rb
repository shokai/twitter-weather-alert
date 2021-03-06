#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'rubygems'
require 'bundler'
Bundler.require

args = ArgsParser.parse ARGV do
  arg :twitter, 'twitter username'
  arg :prefix, 'tweet prefix'
  arg :city, '地域'
  arg :rain, '降水確率のしきい値', :default => 40
  arg :help, 'show help', :alias => :h
end

if args.has_option? :help
  STDERR.puts args.help
  STDERR.puts
  STDERR.puts "e.g."
  STDERR.puts "  % #{$0} -twitter shokai -city 東京"
  exit 1
end

tw = Tw::Client.new
tw.auth args[:twitter]
weather = WeatherJp.get args[:city]
if weather.today.rain < args[:rain]
  puts weather.today
else
  tw.tweet "#{args[:prefix]} #{weather.today}".strip
end
