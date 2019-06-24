require 'net/http'
require 'net/https'
require 'uri'
require 'json'

uri = URI.parse('https://sandbox.parcelwhite.com/api/v1/shipments')

payload = {
  incoterm: 'DDP',
  freight_service_code: 'TESTING',
  transportation_mode: 'air',
  ship_to: {
    name: 'Consignee',
    street1: '1509 W 56th St',
    city: 'Los Angeles',
    state: 'CA',
    postal_code: '90062',
    country_code: 'US',
    phone: '(123) 456-7890'
  },
  ship_from: {
    name: 'Shipper',
    street1: 'street1',
    city: 'Shenzhen',
    state: 'Guangdong',
    postal_code: '518000',
    country_code: 'CN',
    phone: '0755 12345678'
  },
  parcels: [
    {
      est_weight: 0.4,
      line_items: [
        {
          sku: 'RED41-ARCH-SUPPORT',
          name: 'Breathable Shoes',
          material: 'rubber',
          name_of_origin: '运动鞋',
          unit_price: 9,
          quantity: 1,
          taric_code: '6601999000',
          ecommerce_name: 'ALIEXPRESS'
        }
      ]
    }
  ]
}

# HTTP Headers
headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  # 'Accept-Language' => 'zh-cn',
  'Authorization' => 'Bearer replace_access_token_here'
}

https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true
request = Net::HTTP::Post.new(uri.request_uri, headers)
request.body = payload.to_json

# Send the request
response = https.request(request)

puts "Headers: #{response.to_hash.inspect}"
puts response.body

case response
when Net::HTTPCreated
  # shipment created
end
