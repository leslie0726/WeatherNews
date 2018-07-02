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
    getChart("馬祖")
  end
  
  def getChart(site)
    labels = []
    data = []
    @weathers.each do |weather|
      if weather.siteName == site
        labels.push(weather.dataCreationDate)
        data.push(weather.temperature)
      end
    end
    
    
    @data = {
      labels: labels,
      datasets: [
        {
            label: "My First dataset",
            backgroundColor: "rgba(220,220,220,0.2)",
            borderColor: "rgba(220,220,220,1)",
            data: data
        }
      ]
    }
  end
end
