Rails.application.routes.draw do
  get 'weathers/weatherList/:site', :to => 'weathers#weatherList', :as => :weathers_weatherList
end
