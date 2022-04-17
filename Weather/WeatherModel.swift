

import UIKit

struct ForecastDay: Codable,Equatable{
    var weekDay : String?
    var hourForecast : [ForecastDayInfo]?
}


struct ForecastDayInfo:Codable,Equatable{
    var minTemp: Double
    var maxTemp: Double
    var icon: String
    var time: String
    var name : String
    var temp : Double
    var description : String
    var wind : Double
    var date : String
    var simpleDescription: String
}

//JSON MODEL
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






