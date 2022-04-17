//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 14.4.22..
//

import UIKit

struct WeatherViewModel{
let weatherDay: ForecastDay

    var day: String?{
        guard let weekDay = weatherDay.weekDay else{return nil}
        return "\(String(describing: weekDay))"
    }
    var minTemp: String?{
        guard let minTemp = weatherDay.hourForecast?[0].minTemp.toInt() else{return nil}
        return "\(String(describing: minTemp))"
    }
    var maxTemp: String?{
        guard let maxTemp = weatherDay.hourForecast?[0].maxTemp.toInt() else {return nil}
        return "\(String(describing: maxTemp))"
    }
    var url : String?{
        guard let icon = weatherDay.hourForecast?[0].icon else {return nil}
        return  "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
}
protocol WeatherDayRepresentable {

    var day: String? { get }
    var minTemp: String? { get }
    var maxTemp: String? { get }
    var url : String? { get }
    
}
extension WeatherViewModel: WeatherDayRepresentable{}
