require 'spec_helper'

RSpec.describe Analyzer do
  let(:fake_xml) { File.open('spec/sample.xml').read }

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
    context 'with a valid tag' do
      it 'calls #download_xml' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject).to receive(:download_xml)

        subject.children_from_tag('SPEAKER')
      end

      let(:array_tag_children) {
        [ 'First Witch',
          'Second Witch',
          'Third Witch',
          'First Witch',
          'Second Witch',
          'Third Witch',
          'First Witch',
          'Second Witch',
          'ALL']
        }

      it 'parses the given xml tag children values into an array' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.children_from_tag('SPEAKER')).to eq(array_tag_children)
      end
    end
  end

  describe '#word_count_by' do
    context 'with default method tag argument' do
      let(:word_count_hash) { { 'First Witch' => 3, 'Second Witch' => 3, 'Third Witch' => 2, 'ALL' => 1 } }

      it 'returns a hash with key: tag_children_value and value: word_count' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.word_count_by('SPEAKER')).to eq(word_count_hash)
      end
    end

    context 'with a given method tag argument' do
      let(:word_count_hash) { [ 'When shall we three meet again', 1 ] }

      it 'returns a hash { tag_children_value => word_count }' do
        allow(subject).to receive(:open).and_return(tempfile)

        expect(subject.word_count_by('LINE').first).to eq(word_count_hash)
      end
    end

    context 'with nil tag argument' do
      it 'returns an empty array' do
        expect(subject.word_count_by(nil)).to eq([])
      end
    end

    context 'with an empty string tag argument' do
      it 'returns an empty array' do
        expect(subject.word_count_by('')).to eq([])
      end
    end
  end

  describe '#sort_by_descending_word_count' do
    context 'returns the sorted tag/word_count hash' do
      let(:word_count_hash) { { 'First Witch' => 3, 'Second Witch' => 3, 'Third Witch' => 2 } }

      context 'without the key ALL' do
        it 'returns the hash sorted by its values' do
          allow(subject).to receive(:open).and_return(tempfile)

          expect(subject.sort_by_reversed_word_count).to eq(word_count_hash)
        end
      end

      context 'without the key "First Witch"' do
        let(:word_count_hash) { { 'Second Witch' => 3, 'Third Witch' => 2, 'ALL' => 1 } }

        it 'returns the hash sorted by its values with all the keys' do
          allow(subject).to receive(:open).and_return(tempfile)

          expect(subject.sort_by_reversed_word_count('SPEAKER', 'First Witch')).to eq(word_count_hash)
        end
      end

      context 'with all keys included' do
        let(:word_count_hash) { { 'First Witch' => 3, 'Second Witch' => 3, 'Third Witch' => 2, 'ALL' => 1 } }

        it 'returns the hash sorted by its values with all the keys' do
          allow(subject).to receive(:open).and_return(tempfile)

          expect(subject.sort_by_reversed_word_count('SPEAKER', nil)).to eq(word_count_hash)
        end
      end

      context 'with nil tag argument' do
        it 'returns an empty array' do
          expect(subject.sort_by_reversed_word_count(nil)).to eq([])
        end
      end

      context 'with empty string tag argument' do
        it 'returns an empty array' do
          expect(subject.sort_by_reversed_word_count('')).to eq([])
        end
      end
    end
  end
end