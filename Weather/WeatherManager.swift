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
                //listIndex:first 7 will be today untill 21h 8 will be today+1 at 00:00
                let viewModel = ManagerViewModel(weatherDay: decodedJSON)
                
                let tempMin = viewModel.tempMin(for: listIndex)
                let tempMax = viewModel.tempMax(for: listIndex)
                let icon = viewModel.iconPic(for: listIndex)
                let time = viewModel.time(for: listIndex)
                let dates = viewModel.date(for: listIndex)
                let cityName = viewModel.cityName
                let currentTemperature = viewModel.currentTemperature(for: listIndex)
                let description = viewModel.description(for: listIndex)
                let wind = viewModel.wind(for: listIndex)
                let simpleDescription = viewModel.simpleDescription(for: listIndex)
                let date = viewModel.fullDate(for: listIndex)
                
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
                    getData(forecast: &secondDayForecast, day: &secondDayTemp)
                    if forecastModelArray.count <= 1{
                        forecastModelArray.append(secondDayTemp)
                    }
                } else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 2) {
                    getData(forecast: &thirdDayForecast, day: &thirdDayTemp)
                    if forecastModelArray.count <= 2{
                        forecastModelArray.append(thirdDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 3) {
                    getData(forecast: &fourthDayForecast, day: &fourthDayTemp)
                    if forecastModelArray.count <= 3{
                        forecastModelArray.append(fourthDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 4) {
                    getData(forecast: &fifthDayForecast, day: &fifthDayTemp)
                    if forecastModelArray.count <= 4{
                        forecastModelArray.append(fifthDayTemp)
                    }
                }else if weekDayComponent == currentWeekDay.incrementWeekDays(by: 5) {
                    getData(forecast: &sixthDayForecast, day: &sixthDayTemp)
                    if forecastModelArray.count <= 5{
                        forecastModelArray.append(sixthDayTemp)
                    }
                }
                func getData(forecast currentDayForecast: inout [ForecastDayInfo] , day currentDay: inout ForecastDay){
                    let info = ForecastDayInfo(minTemp: tempMin, maxTemp: tempMax, icon: icon, time: time, name: cityName, temp: currentTemperature,description:description,wind: wind,date: dates, simpleDescription: simpleDescription)
                    currentDayForecast.append(info)
                    currentDay = ForecastDay(weekDay: weekDay, hourForecast: currentDayForecast)
                    fetchedData.append(info)
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


