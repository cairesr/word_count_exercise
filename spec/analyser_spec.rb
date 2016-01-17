require 'spec_helper'

RSpec.describe Analyzer do
  context '#validate_url' do
    context 'with a nil url' do
      subject { Analyzer.new(nil) }

      it 'raises an ArgumentError' do
        expect { subject.validate_url }.to raise_error(ArgumentError)
      end
    end

    context 'with an invalid url' do
      subject { Analyzer.new('http:/|www.luv.com') }

      it 'raises URI::InvalidURIError' do
        expect { subject.validate_url }.to raise_error(URI::InvalidURIError)
      end
    end

    context 'with the default url attribute' do
      it 'uses the default url value' do
        expect(subject.validate_url).to eq(subject.remote_file_url)
      end
    end
  end
end