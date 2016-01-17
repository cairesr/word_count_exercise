require 'spec_helper'

RSpec.describe Analyzer do
  let(:fake_xml) { '<?xml version="1.0"?><BIG_TAG><SPEAKER>fluffy character</SPEAKER><AUTHOR>shakespeare</AUTHOR></BIG_TAG>' }

  let(:tempfile) do
    tempfile = Tempfile.new('donwloaded')
    tempfile.write(fake_xml)
    tempfile.rewind

    tempfile
  end

  describe '#validate_url' do
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

  describe '#download_xml' do
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

  describe '#children_from_tag' do
    it 'calls #download_xml' do
      allow(subject).to receive(:open).and_return(tempfile)

      expect(subject).to receive(:download_xml)

      subject.children_from_tag
    end

    context 'with default method tag argument' do
      let(:array_tag_children) { ['fluffy character'] }

      it 'parses the given xml tag children values into an array' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.children_from_tag).to eq(array_tag_children)
      end
    end

    context 'with a given method tag argument' do
      let(:array_tag_children) { ['shakespeare'] }

      it 'parses the given xml tag children values into an array' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.children_from_tag('AUTHOR')).to eq(array_tag_children)
      end
    end
  end
end