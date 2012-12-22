class Zeo
  require 'httparty'
  include HTTParty
  key = '1FF64ED0EAD816DC6A3D2218B6FAFFBB'
  base_uri "https://api.myzeo.com:8443/zeows/api/v1/sleeperService"
  

  def initialize()
    @api_key = '1FF64ED0EAD816DC6A3D2218B6FAFFBB' 
    Zeo.basic_auth 'pdarche@gmail.com', 'Morgortbort1'
    
  end

  def yesterdays_data()
  	month = Date.today().month
  	day = Date.today().day
  	year = Date.today().year
  	day = day - 1

  	date = year.to_s + '-' + month.to_s + '-' + day.to_s

  	Zeo.get("/getSleepStatsForDate?key=#{@api_key}", :query => {:date => date}, :headers => {"referer" => "127.0.0.1", "accept" => "application/json" })
  end 

end