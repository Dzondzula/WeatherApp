//
//  ManagerViewModel.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 15.4.22..
//

import Foundation

struct ManagerViewModel{
    
    let weatherDay : ForecastResponse
    
    func tempMin(for index: Int) -> Double{
        let weather = weatherDay.list[index]
        return weather.main.temp_min
    }
    func tempMax(for index: Int) -> Double{
        let weather = weatherDay.list[index]
        return weather.main.temp_max
    }
    func iconPic(for index: Int) -> String{
        let weather = weatherDay.list[index]
        return weather.weather[0].icon
    }
    func time(for index: Int) -> String{
        let weather = weatherDay.list[index]
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeDateFormatter = DateFormatter()
        timeDateFormatter.dateFormat = "HH:mm"
        let hour = fullDateFormatter.date(from: weather.dt_txt)
        let time = timeDateFormatter.string(from: hour!)
        return time
    }
    func date(for index: Int)-> String{
        let weather = weatherDay.list[index]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let detailDate = fullDateFormatter.date(from: weather.dt_txt)
        let date = dateFormatter.string(from: detailDate!)
        return date
    }

    var cityName: String{
        
        return weatherDay.city.name
    }
    func currentTemperature(for index: Int)-> Double{
        let weather = weatherDay.list[index]
        return weather.main.temp
    }
   
    func description(for index: Int)-> String{
        let weather = weatherDay.list[index]
        return weather.weather[0].description
    }
    func wind(for index: Int)-> Double{
        let weather = weatherDay.list[index]
        return weather.wind.speed
    }
    func simpleDescription(for index: Int)-> String{
        let weather = weatherDay.list[index]
        return  weather.weather[0].main
    }
    func fullDate(for index: Int)-> Date?{
        let weather = weatherDay.list[index]
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: weather.dt_txt)
        return date
    }
}



//let dateFormatter = DateFormatter()
//dateFormatter.calendar = Calendar(identifier: .gregorian)
//dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//let date = dateFormatter.date(from: decodedJSON.list[listIndex].dt_txt)
//
//let components = Calendar.current.dateComponents([.weekday], from: date!)
//let weekDayComponent = components.weekday! - 1
//
//let formater = DateFormatter()
//let weekDay = formater.weekdaySymbols[weekDayComponent]
//
//let currentDayComponent = Calendar.current.dateComponents([.weekday], from: Date())
//let currentWeekDay = currentDayComponent.weekday! - 1
//let currentWeekDaySymbol = formater.weekdaySymbols[currentWeekDay]
