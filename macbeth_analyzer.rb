require_relative 'lib/analyzer'

Analyzer.new.sort_by_reversed_word_count.each {|k, v| puts "#{k}, #{v}"}