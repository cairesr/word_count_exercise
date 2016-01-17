require 'uri'

class Analyzer
  def download_xml(remote_file_url='http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml')
  	raise ArgumentError, 'An url should be provided' if remote_file_url.nil?

  	URI.parse remote_file_url

  	nil
	end
end