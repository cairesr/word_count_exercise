#Dir[File.dirname(__FILE__) + '/*.rb'].each {|file| require file }
require_relative 'analyzer'

Analyzer.new.sort_by_reversed_word_count.each {|k, v| puts "#{k}, #{v}"}