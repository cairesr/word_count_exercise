require 'uri'

class Analyzer
  def validate_url(remote_file_url='http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
  	raise ArgumentError, 'An url should be provided' if remote_file_url.nil?

  	URI.parse remote_file_url

  	remote_file_url
  end
end