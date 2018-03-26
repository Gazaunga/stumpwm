#!/usr/bin/env ruby

require 'fileutils'

DESTINATION = "#{Dir.home}/"

Dir.glob("#{Dir.home}/stumpwm/**", File::FNM_DOTMATCH).each { |f| FileUtils.cp_r("#{f}", "#{DESTINATION}", :verbose => true) }
