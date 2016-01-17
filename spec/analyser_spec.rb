require 'spec_helper'

RSpec.describe Analyzer, "#download_xml" do
  subject(:analyzer) { Analyzer.new }

  context 'with a nil url' do
  	it 'raises an ArgumentError' do
  	  expect { analyzer.download_xml(nil) }.to raise_error(ArgumentError)
  	end
  end

  context 'with an invalid url' do
  	it 'raises URI::InvalidURIError' do
  	  expect { analyzer.download_xml('http:/|www.luv.com') }.to raise_error(URI::InvalidURIError)
  	end
  end
end