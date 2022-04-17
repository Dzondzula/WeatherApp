//
//  WeatherManagerViewModel.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 14.4.22..
//

import UIKit

struct WeatherDayViewModel{
    
    var wetherDay: [ForecastDay]
    
    
    func minTemp(for index: Int) -> String?{
        let weatherDayData = wetherDay[index]
        guard let minTemp = weatherDayData.hourForecast?[0].minTemp.toInt() else {return nil}
        return "\(String(describing: minTemp))"
    }
    func day(for index: Int) -> String?{
        let weatherDayData = wetherDay[index]
        guard let weekDay = weatherDayData.weekDay else {return nil}
        return "\(String(describing: weekDay))"
    }
    func maxTemp(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let maxTemp = weatherDayData.hourForecast?[0].minTemp.toInt() else {return nil}
        return "\(String(describing: maxTemp))"
    }
    func wind(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let wind = weatherDayData.hourForecast?[0].wind.kmh() else {return nil}
        return "Wind: \(String(describing: wind)) km/h"
    }
    func description(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let description = weatherDayData.hourForecast?[0].simpleDescription else {return nil}
        return "\(String(describing: description))"
    }
    func temperature(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let temperature = weatherDayData.hourForecast?[0].temp.toInt() else {return nil}
        return "\(String(describing: temperature)) °C"
    }
    func place(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let place = weatherDayData.hourForecast?[0].name else {return nil}
        return "\(String(describing: place))"
    }
    func time(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let time = weatherDayData.hourForecast?[0].time else {return nil}
        return "\(String(describing:time))"
    }
    func urlString(for index: Int)-> String?{
        let weatherDayData = wetherDay[index]
        guard let icon = weatherDayData.hourForecast?[0].icon else {return nil}
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
   
    func viewModel(for index: Int)-> WeatherViewModel{
        return WeatherViewModel(weatherDay: wetherDay[index])
    }
}



