#!/usr/bin/env ruby

require 'fileutils'

DESTINATION = "#{Dir.home}/"

Dir.glob("#{Dir.home}/stumpwm/**").each { |f| FileUtils.cp_r("#{f}", "#{DESTINATION}", :verbose => true) }
