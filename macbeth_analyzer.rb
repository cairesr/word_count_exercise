Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

Analyzer.new.sort_by_reversed_word_count.each {|k, v| puts "#{k}, #{v}"}