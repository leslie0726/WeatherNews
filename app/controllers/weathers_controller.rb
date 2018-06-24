require 'net/http'

class WeathersController < ApplicationController

  def weatherList
    @weathers = []
    
    uri = URI('https://opendata.epa.gov.tw/ws/Data/ATM00698/?$format=json')
    resp = Net::HTTP.get(uri)
    result = JSON.parse(resp)
    result.each do |data|
      dataCreationDate = data["DataCreationDate"]
      weather = Weather.new
      
      dataCreationDateStr =data["DataCreationDate"].split("/")
      dataCreationDate = (dataCreationDateStr[0].to_i+1911).to_s+"/"+dataCreationDateStr[1]+"/"+dataCreationDateStr[2]
      weather.siteName=data["SiteName"]
      weather.windDirection = data["WindDirection"]
      weather.windPower=data["WindPower"]
      weather.temperature=data["Temperature"]
      weather.weather=data["Weather"]
      weather.dataCreationDate=dataCreationDate
      
      @weathers << weather
    end
  end
end
