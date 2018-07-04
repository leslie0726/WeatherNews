require 'net/http'

class WeathersController < ApplicationController

  def weatherList()
    @site = params[:site];
    @select = []
    @siteData = []
    @weathers = []
    uri = URI('https://opendata.epa.gov.tw/ws/Data/ATM00698/?$format=json')
    resp = Net::HTTP.get(uri)
    result = JSON.parse(resp)
    result.each do |data|
      @select << data["SiteName"] if !@select.include?(data["SiteName"]);
      if data["SiteName"] == @site
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
        if !@siteData.include?(data["SiteName"]+dataCreationDate)
          @weathers << weather 
          @siteData << (data["SiteName"]+dataCreationDate)
        end
      end
    end
    getChart(@site)
  end
  
  
  
  def getChart(site)
    chart_data = getChartData(site)
    
    chart_data = chart_data.sort.to_h
    labels = chart_data.keys
    data = chart_data.values

    @data = {
      labels: labels,
      datasets: [
        {
            label: site,
            backgroundColor: "rgba(220,220,220,0.2)",
            borderColor: "rgba(220,220,220,1)",
            data: data
        },
      ]
    }
    @options = {height: 200}
  end
  
  
  
  def getChartData(site)
    chart_data = Hash.new(0)
    
    @weathers.each do |weather|
      if weather.siteName == site
        l = weather.dataCreationDate.strftime("%F %T")
        d = weather.temperature.split("(")[0]
        chart_data.store(l ,d)
      end
    end
    
    return chart_data
  end
end
