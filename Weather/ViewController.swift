//
//  ViewController.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 3.12.21..
//

import UIKit
import CoreLocation
class ViewController: UIViewController,CLLocationManagerDelegate{
   
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    var forecast :[ForecastDay] = []
    var currentLocation : CLLocation!
    let locationManager = CLLocationManager()
    var currentDay : String!

    var backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var collectionV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        backgroundImage.image = UIImage(named: "sunny.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty,currentLocation == nil{
            currentLocation = locations.first
            locationManager.startUpdatingLocation()
            requestWeatherData()
        }
    }
    func requestWeatherData() {
        DispatchQueue.global(qos: .userInitiated).async{ [weak self] in
            guard let currentLocation = self?.currentLocation else {return}
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        var currentDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var secondDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var thirdDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var fourthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var fifthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var sixthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)

        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&units=metric&appid=6f82f48c92e97ee65b96d117f86d4e0d"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { data, _,_ in
            if let jsonData = data{
                if let decodedJSON = try?
                  
                    JSONDecoder().decode(ForecastResponse.self,from: jsonData){
                   
                    var forecastModelArray : [ForecastDay] = []
                    var fetchedData : [ForecastDayInfo] = []
                    
                    var currentDayForecast : [ForecastDayInfo] = []
                    var secondDayForecast : [ForecastDayInfo] = []
                    var thirdDayForecast : [ForecastDayInfo] = []
                    var fourthDayForecast : [ForecastDayInfo] = []
                    var fifthDayForecast : [ForecastDayInfo] = []
                    var sixthDayForecast : [ForecastDayInfo] = []
                                        
                    
                    for day in 0...decodedJSON.list.count - 1{
                        
                        let listIndex = day
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
                       
                        let url = URL(string: "https://openweathermap.org/img/wn/\(currentDayForecast[0].icon)@2x.png")
                        DispatchQueue.main.async { [weak self] in
                            self?.forecast = forecastModelArray
                           
                            self?.temperature.text = "\(currentDayForecast[0].temp.toInt() ?? 0)°C"
                            self?.wind.text = "Wind: \(currentDayForecast[0].wind.kmh() ?? 0)km/h"
                            self?.place.text = "\(currentDayForecast[0].name)"
                            self?.day.text = "\(currentDayForecast[0].date)"
                            self?.time.text = "\(currentDayForecast[0].time)"
                            self?.descriptions.text = "\(currentDayForecast[0].simpleDescription)"
                            self?.collectionV.reloadData()
                            self?.viewImage.loadImage(url: url!)
                        }
                }
            }
            }
            
        }.resume()
        
        
}
    }
}


extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .init(white: 1, alpha:0.1)
        cell.config(with: forecast[indexPath.item])
        cell.layer.cornerRadius = 8.0
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let forecast = forecast[indexPath.item]
        place.text = "\(forecast.hourForecast![0].name )"
        day.text = "\(forecast.hourForecast![0].date)"
        wind.text = "\(forecast.hourForecast![0].wind.kmh() ?? 0) km/h"
        time.text = "\(forecast.hourForecast![0].time)"
        descriptions.text = "\(forecast.hourForecast![0].simpleDescription)"
        temperature.text = "\(forecast.hourForecast![0].temp.toInt() ?? 0)°C"
        let url = URL(string: "https://openweathermap.org/img/wn/\(forecast.hourForecast![0].icon)@2x.png")

        viewImage.loadImage(url: url!)

    }


}

extension ViewController: UISearchBarDelegate{
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {return}
        let city = searchText.replacingOccurrences(of: " ", with: "+")
        var currentDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var secondDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var thirdDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var fourthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var fifthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)
        var sixthDayTemp = ForecastDay(weekDay: nil, hourForecast: nil)

        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&appid=6f82f48c92e97ee65b96d117f86d4e0d"
        let url = URL(string: urlString)!
        DispatchQueue.global(qos: .userInitiated).async {
        URLSession.shared.dataTask(with: url) { data, _,_ in
            if let jsonData = data{
                if let decodedJSON = try?
                  
                    JSONDecoder().decode(ForecastResponse.self,from: jsonData){
                   
                    var forecastModelArray : [ForecastDay] = []
                    var fetchedData : [ForecastDayInfo] = []
                    
                    var currentDayForecast : [ForecastDayInfo] = []
                    var secondDayForecast : [ForecastDayInfo] = []
                    var thirdDayForecast : [ForecastDayInfo] = []
                    var fourthDayForecast : [ForecastDayInfo] = []
                    var fifthDayForecast : [ForecastDayInfo] = []
                    var sixthDayForecast : [ForecastDayInfo] = []
                                        
                    
                    for day in 0...decodedJSON.list.count - 1{
                        
                        let listIndex = day
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
                        let url = URL(string: "https://openweathermap.org/img/wn/\(currentDayForecast[0].icon)@2x.png")
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.forecast = forecastModelArray
                           
                            self?.forecast = forecastModelArray
                           
                            self?.temperature.text = "\(currentDayForecast[0].temp.toInt() ?? 0)°C"
                            self?.wind.text = "\(currentDayForecast[0].wind.kmh() ?? 0) km/h"
                            self?.place.text = "\(currentDayForecast[0].name)"
                            self?.day.text = "\(currentDayForecast[0].date)"
                            self?.time.text = "\(currentDayForecast[0].time)"
                            self?.descriptions.text = "\(currentDayForecast[0].simpleDescription)"
                            self?.viewImage.loadImage(url: url!)
                            self?.collectionV.reloadData()
                           
                        }
                }
            }
            }
            
        }.resume()
        }
    
    }
    
}



