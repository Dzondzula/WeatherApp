//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 30.3.22..
//
import MapKit
import Foundation
import CoreLocation


    enum MyError: Error{
        case noDataAvailable
    }
    
struct ForecastEndPoint{
    
    static func url(_ lat: String? = nil, _ long: String? = nil, _ city: String? = nil) -> URL {
        let urlString : String!
        
        switch city{
        case .some(let value):
            urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(value)&units=metric&appid=6f82f48c92e97ee65b96d117f86d4e0d"
        case .none:
            urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat!)&lon=\(long!)&units=metric&appid=6f82f48c92e97ee65b96d117f86d4e0d"
        }
        return URL(string: urlString)!
    }
    
    
    static func parse(data: Data, response: URLResponse) throws ->[ForecastDay]{
        var decodedData : [ForecastDay]!
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else{
                  throw MyError.noDataAvailable
              }
        if let decodedJSON = try? JSONDecoder().decode(ForecastResponse.self, from: data){
            
            var currentDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            var secondDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            var thirdDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            var fourthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            var fifthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            var sixthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
            
            var forecastModelArray : [ForecastDay] = []
            var fetchedData : [ForecastDayInfo] = []
            
            var currentDayForecast : [ForecastDayInfo] = []
            var secondDayForecast : [ForecastDayInfo] = []
            var thirdDayForecast : [ForecastDayInfo] = []
            var fourthDayForecast : [ForecastDayInfo] = []
            var fifthDayForecast : [ForecastDayInfo] = []
            var sixthDayForecast : [ForecastDayInfo] = []
            
            
            for listIndex in 0...decodedJSON.list.count - 1{
                
                
                let tempMin = decodedJSON.list[listIndex].main.temp_min
                let tempMax = decodedJSON.list[listIndex].main.temp_max
                let icon = decodedJSON.list[listIndex].weather[0].icon
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "HH:mm"
                let hour = dateFormatterGet.date(from:  decodedJSON.list[listIndex].dt_txt)
                let time = dateFormatter1.string(from: hour!)
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyy-MM-dd"
                let detailDate = dateFormatterGet.date(from:  decodedJSON.list[listIndex].dt_txt)
                let dates = dateFormatter2.string(from: detailDate!)
                
                let cityName = decodedJSON.city.name
                let currentTemperature = decodedJSON.list[listIndex].main.temp
                let description = decodedJSON.list[listIndex].weather.description
                let wind = decodedJSON.list[listIndex].wind.speed
                let simpleDescription = decodedJSON.list[listIndex].weather[0].main
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: decodedJSON.list[listIndex].dt_txt)
                
                let components = Calendar.current.dateComponents([.weekday], from: date!)
                let weekDayComponent = components.weekday! - 1
                
                let formater = DateFormatter()
                let weekDay = formater.weekdaySymbols[weekDayComponent]
                
                let currentDayComponent = Calendar.current.dateComponents([.weekday], from: Date())
                let currentWeekDay = currentDayComponent.weekday! - 1
                let currentWeekDaySymbol = formater.weekdaySymbols[currentWeekDay]
                
                
                if weekDayComponent == currentWeekDay {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    currentDayForecast.append( info)
                    currentDayTemp = ForecastDay(weekDay: currentWeekDaySymbol, hourForecast: currentDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 0{
                        forecastModelArray.append(currentDayTemp)
                    }
                } else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 1) {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    secondDayForecast.append( info)
                    secondDayTemp = ForecastDay(weekDay: weekDay, hourForecast: secondDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 1{
                        forecastModelArray.append(secondDayTemp)
                    }
                } else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 2) {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    thirdDayForecast.append( info)
                    thirdDayTemp = ForecastDay(weekDay: weekDay, hourForecast: thirdDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 2{
                        forecastModelArray.append(thirdDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 3) {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    fourthDayForecast.append(info)
                    fourthDayTemp = ForecastDay(weekDay: weekDay, hourForecast: fourthDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 3{
                        forecastModelArray.append(fourthDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 4) {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    fifthDayForecast.append(info)
                    fifthDayTemp = ForecastDay(weekDay: weekDay, hourForecast: fifthDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 4{
                        forecastModelArray.append(fifthDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 5) {
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    sixthDayForecast.append(info)
                    sixthDayTemp = ForecastDay(weekDay: weekDay, hourForecast: sixthDayForecast)
                    fetchedData.append(info)
                    if forecastModelArray.count <= 5{
                        forecastModelArray.append(sixthDayTemp)
                    }
                }
                
            }
            decodedData = forecastModelArray
        }//if let end
        return decodedData
    }
}


protocol URLSessionProtocol{
    func data(from url: URL, delegate: URLSessionTaskDelegate?  ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol{
    
}

