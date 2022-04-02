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
    var session : URLSessionProtocol = URLSession.shared
  
    var forecast :[ForecastDay] = []{
        didSet{
            handleResults(forecast)
        }
    }
    var handleResults: ([ForecastDay]) -> Void = { print($0) }
    var currentLocation : CLLocation!
    let locationManager = CLLocationManager()
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])  {
        if !locations.isEmpty,currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            Task{
                await requestWeatherData()
            }
        }
    }
    
    func requestWeatherData() async {
        
        guard let currentLocation = currentLocation else {return}
        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude
        let long = longitude.description
        let lat = latitude.description
        
        let data = await fetchForecastForMyLocation(lat, long)
        switch data{
        case .success(let info):
            self.forecast = info
            if let forecastData = forecast[0].hourForecast?[0]{
                DispatchQueue.main.async{
                    let url = URL(string: "https://openweathermap.org/img/wn/\(forecastData.icon)@2x.png")
                    self.wind.text = "Wind: \(forecastData.wind.kmh() ?? 0)km/h"
                    self.place.text = "\(forecastData.name)"
                    self.day.text = "\(forecastData.date)"
                    self.time.text = "\(forecastData.time)"
                    self.descriptions.text = "\(forecastData.simpleDescription)"
                    self.viewImage.loadImage(url: url!)
                    self.temperature.text = "\(forecastData.temp.toInt() ?? 0)°C"
                    self.collectionV.reloadData()
                }
            }
        case .failure(let error):
            print("\(error.localizedDescription)")
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        guard let searchText = searchBar.text else {return}
        let city = searchText.replacingOccurrences(of: " ", with: "+")
        Task{
            let data = await fetchForecastForMyLocation(nil,nil,city)
            switch data{
            case .success(let info):
                self.forecast = info
                
                if let forecastData = forecast[0].hourForecast?[0]{
                    DispatchQueue.main.async{
                        let url = URL(string: "https://openweathermap.org/img/wn/\(forecastData.icon)@2x.png")
                        self.wind.text = "Wind: \(forecastData.wind.kmh() ?? 0)km/h"
                        self.place.text = "\(forecastData.name)"
                        self.day.text = "\(forecastData.date)"
                        self.time.text = "\(forecastData.time)"
                        self.descriptions.text = "\(forecastData.simpleDescription)"
                        self.viewImage.loadImage(url: url!)
                        self.temperature.text = "\(forecastData.temp.toInt() ?? 0)°C"
                        
                        self.collectionV.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
        
    }
    
    func fetchForecastForMyLocation(_ lat: String? = nil, _ long: String? = nil, _ city: String? = nil) async -> Result<[ForecastDay],MyError>{
       
        do{
            let url = ForecastEndPoint.url(lat, long, city)
            let (data, response) = try await session.data(from: url, delegate: nil)
            return try .success(ForecastEndPoint.parse(data: data, response: response))
        } catch{
            return .failure(MyError.noDataAvailable)
            
        }
    }
}



