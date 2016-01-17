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

  context '#download_xml' do
  	let(:fake_xml) { '<xml><speaker>Hi</speaker></xml>' }

    let(:tempfile) do
      tempfile = Tempfile.new('donwloaded')
      tempfile.write(fake_xml)
      tempfile.rewind

      tempfile
    end

    context 'with a valid url call' do
      it 'returns the downloaded content' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.download_xml).to eq(fake_xml)
      end
    end

    context 'when executed' do
      it 'calls #validate_url' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject).to receive(:validate_url)

        subject.download_xml
      end
    end
  end
end