require 'net/http'
require 'net/https'
require 'uri'
require 'json'

uri = URI.parse('https://sandbox.parcelwhite.com/api/v1/parcels/JXA5FV27U001')

# HTTP Headers
headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  # 'Accept-Language' => 'zh-cn',
  'Authorization' => 'Bearer replace_access_token_here'
}

https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = uri.scheme == 'https'
request = Net::HTTP::Get.new(uri.request_uri, headers)

# Send the request
response = https.request(request)

puts "Headers: #{response.to_hash.inspect}"
# puts response.body

case response
when Net::HTTPSuccess
  data = JSON.parse(response.body)
  puts data['postage_label']['tracking_code']
  puts data['label_url']

  # Download postage label
  uri = URI.parse(data['label_url'])
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  request = Net::HTTP::Get.new(uri.request_uri, headers)
  resp = http.request(request)

  case resp
  when Net::HTTPSuccess
    File.open('label.pdf', 'wb') do |fp|
      fp.write(resp.body)
    end
  end
end