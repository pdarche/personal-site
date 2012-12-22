# require 'crazylegs'
# require 'httparty'
# require 'json'

include Crazylegs
consumer_key = "YBT3QATFK3NCGWXT3EKEV2NC6GUHJM2IWLSGK4NEANZHUWDVKUOA"
consumer_secret = "DUHON4YZGHHZL8NUGG4WKBDVTZTCGE0C3AHRYC25SI8CP06BTL1B6PTYNXQ7XH5N"
base_url = "https://openpaths.cc/api/1"
credentials = Credentials.new(consumer_key,consumer_secret)
url = SignedURL.new(credentials, base_url,'GET')
signed_url = url.full_url
resp = HTTParty.get(signed_url)

#post
# url = SignedURL.new(credentials, base_url,'POST')
# signed_url,headers = url.full_url_using_headers
res = HTTParty.get(signed_url, :headers => headers)
parsed = JSON.parse(res.parsed_response)
