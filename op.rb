require 'crazylegs'
require 'httparty'
require 'json'

include Crazylegs
consumer_key = "YBT3QATFK3NCGWXT3EKEV2NC6GUHJM2IWLSGK4NEANZHUWDVKUOA"
consumer_secret = "DUHON4YZGHHZL8NUGG4WKBDVTZTCGE0C3AHRYC25SI8CP06BTL1B6PTYNXQ7XH5N"

# logger = Logger.new(STDERR)
# logger.level = Logger::DEBUG

now = Time.now.to_i
yesterday = now - ( 24 * 60 * 60 ) 
base_url = "https://openpaths.cc/api/1"
credentials = Credentials.new(consumer_key,consumer_secret)
url = SignedURL.new(credentials, base_url, 'GET')
signed_url = url.full_url
res = HTTParty.get(signed_url)

parsed = JSON.parse(res.parsed_response)

#post
url = SignedURL.new(credentials, base_url,'POST')
url['start_time'] = yesterday
url['end_time'] = now

signed_url,headers = url.full_url_using_headers

res = HTTParty.post(signed_url, :headers => headers)

