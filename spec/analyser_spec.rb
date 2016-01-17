require 'spec_helper'

RSpec.describe Analyzer, "#validate_url" do
  context 'with a nil url' do
  	it 'raises an ArgumentError' do
  	  expect { subject.validate_url(nil) }.to raise_error(ArgumentError)
  	end
  end

  context 'with an invalid url' do
  	it 'raises URI::InvalidURIError' do
  	  expect { subject.validate_url('http:/|www.luv.com') }.to raise_error(URI::InvalidURIError)
  	end
  end

  context 'with the default url attribute' do
    let(:default_url) { 'http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml' }

    it 'uses method default url value' do
      expect(subject.validate_url).to eq(default_url)
    end
  end
end