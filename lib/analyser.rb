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
end