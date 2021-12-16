

import UIKit

struct ForecastDay{
    let weekDay : String?
    let hourForecast : [ForecastDayInfo]?
}


struct ForecastDayInfo{
    let minTemp: Double
    let maxTemp: Double
    let icon: String
    let time: String
    let name : String
    var temp : Double
    var description : String
    var wind : Double
    var date : String
    var simpleDescription: String
}


struct ForecastResponse : Codable {
    var list : [ForecastDetail]
    var city : CityInfo
    
}

struct ForecastDetail : Codable {
    var dt : Double
    var main : MainInfo
    var weather : [WeatherInfo]
    var wind : WindInfo
    var dt_txt : String
    
}

struct MainInfo : Codable {
    var temp: Double
    var temp_min : Double
    var temp_max : Double
    var humidity : Int
}

struct WeatherInfo : Codable{
    var main : String
    var description : String
    var icon : String
}

struct WindInfo : Codable {
    var speed : Double
}


struct CityInfo : Codable {
    var name : String
    var coord : CityCoordinate
}
struct CityCoordinate: Codable {
    var lat : Float
    var lon : Float
    
}






