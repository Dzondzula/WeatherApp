//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Nikola Andrijasevic on 3.12.21..
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    func config(withViewModel viewModel: WeatherDayRepresentable){
        dayLabel.text = viewModel.day
        minTemp.text = viewModel.minTemp
        maxTemp.text = viewModel.maxTemp
        if let url = viewModel.url{
            imageView.loadImage(url: URL(string: url)!)
        }
    }
//    func config(with item: ForecastDay){
//        dayLabel.text = item.weekDay
//        minTemp.text = "\(item.hourForecast?[0].minTemp ?? 0 )"
//        maxTemp.text = "\(item.hourForecast?[0].maxTemp ?? 0)"
//        let url = URL(string: "https://openweathermap.org/img/wn/\(item.hourForecast![0].icon)@2x.png")
//        imageView.loadImage(url: url!)
//    }
}

extension UIImageView{
    func loadImage(url : URL){
        DispatchQueue.global().async {
            [self] in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
        }
    }
}
