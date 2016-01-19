# Macbeth Character Word Count
[![Build Status](https://travis-ci.org/cairesr/word_count_exercise.svg?branch=master)](https://travis-ci.org/cairesr/word_count_exercise)

Counts how many times a character *speaks* in the Macebeth play.

The main script donwloads a xml and runs the analyzer on it.

# Usage
```
bundle install
ruby macbeth_analyzer.rb
```

It's possible to change the tag to be parsed:
```
require_relative 'analyzer'

Analyzer.new.sort_by_reversed_word_count('TITLE').each {|k, v| puts "#{k}, #{v}"}
```

It's also possible to instantiate the Analyzer to count the words for another play.
```
require_relative 'analyzer'

analyzer = Analyzer.new('http://www.ibiblio.org/xml/examples/shakespeare/othello.xml')
analyzer.sort_by_reversed_word_count.each {|k, v| puts "#{k}, #{v}"}
```

# Run the specs (rspec)
```
rake spec
```
or
```
rspec
```
in the root dir


## Pre-requirement
Ruby >= 2.2.2
