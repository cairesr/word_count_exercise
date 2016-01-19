require 'nokogiri'
require 'open-uri'

class Analyzer

  attr_accessor :remote_file_url

  def initialize(remote_file_url = 'http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
    @remote_file_url = remote_file_url
  end

  def validate_url
    raise ArgumentError, 'An url should be provided' if @remote_file_url.nil?

    URI.parse @remote_file_url

    @remote_file_url
  end

  def download_xml
    validate_url

    open(@remote_file_url, 'rb').read
  end

  def children_from_tag(tag)
    parsed_xml = Nokogiri::XML.parse(download_xml)

    parsed_xml.xpath("//#{tag}").map { |tag| tag.text }
  end

  def word_count_by(tag)
    return [] if tag.nil? || tag.empty?

    children_from_tag(tag).reduce(Hash.new(0)) do |hashy, word|
      hashy[word] += 1

      hashy
    end
  end

  def sort_by_reversed_word_count(tag = 'SPEAKER' , key_to_be_ignored = 'ALL')
    raise ArgumentError, 'A tag should be provided' if tag.nil? || tag.empty?

    sorted_word_count = word_count_by(tag).sort_by { |k, v| v }.reverse.to_h

    sorted_word_count.delete key_to_be_ignored

    sorted_word_count
  end
end