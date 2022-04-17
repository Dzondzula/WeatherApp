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
    
    var forecast :[ForecastDay] = []
    var viewModel: WeatherDayViewModel?{
        didSet{
            //updateView()
        }
    }
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
            self.viewModel = WeatherDayViewModel(wetherDay: forecast)
            if let viewModel = viewModel{
                DispatchQueue.main.async{
                    self.wind.text = viewModel.wind(for: 0)
                    self.place.text = viewModel.place(for: 0)
                    self.day.text = viewModel.day(for: 0)
                    self.time.text = viewModel.time(for: 0)
                    self.descriptions.text = viewModel.description(for: 0)
                    self.temperature.text = viewModel.temperature(for: 0)
                    if let url = viewModel.urlString(for: 0){
                        self.viewImage.loadImage(url: URL(string:url)!)
                    }
                    self.collectionV.reloadData()
                }
            }
        case .failure(let error):
            print("\(error.localizedDescription)")
        }
    }
    private func updateView(){
        collectionV.refreshControl?.endRefreshing()
        if let _ = viewModel{
            collectionV.reloadData()
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
        self.viewModel = WeatherDayViewModel(wetherDay: forecast)
        if let weather = viewModel?.viewModel(for: indexPath.row){
            cell.config(withViewModel: weather)
        }
        
        cell.layer.cornerRadius = 8.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.viewModel = WeatherDayViewModel(wetherDay: forecast)
        if let viewModel = viewModel{
            place.text =  viewModel.place(for: indexPath.row)!
            day.text = viewModel.day(for: indexPath.row)!
            wind.text = viewModel.wind(for: indexPath.row)!
            time.text = viewModel.time(for: indexPath.row)!
            descriptions.text = viewModel.description(for: indexPath.row)!
            temperature.text = viewModel.temperature(for: indexPath.row)
            if let url = viewModel.urlString(for: indexPath.row){
                viewImage.loadImage(url: URL(string: url)!)
            }
        }
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
                self.viewModel = WeatherDayViewModel(wetherDay: forecast)
                if let viewModel = viewModel {
                    DispatchQueue.main.async{
                        
                        self.wind.text = viewModel.wind(for: 0)
                        self.place.text = viewModel.place(for: 0)
                        self.day.text = viewModel.day(for: 0)
                        self.time.text = viewModel.time(for: 0)
                        self.descriptions.text = viewModel.description(for: 0)
                        self.temperature.text = viewModel.temperature(for: 0)
                        if let url = viewModel.urlString(for: 0){
                            self.viewImage.loadImage(url: URL(string:url)!)
                        }
                        
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



