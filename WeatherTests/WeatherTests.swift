//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Nikola Andrijasevic on 30.3.22..
//

import XCTest
@testable import Weather
class WeatherTests: XCTestCase {
    var sut: ViewController!
    var sesssion : MockURLSession!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "ViewController")
        sesssion = MockURLSession()
        sut.session = sesssion
        sut.loadViewIfNeeded()
        
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_OutletsShouldBeConnected(){
        XCTAssertNotNil(sut.temperature)
        XCTAssertNotNil(sut.time)
        XCTAssertNotNil(sut.day)
        XCTAssertNotNil(sut.descriptions)
        XCTAssertNotNil(sut.place)
        XCTAssertNotNil(sut.wind)
        XCTAssertNotNil(sut.viewImage)
        XCTAssertNotNil(sut.search)
    }
    func test_OutletsValuesShouldBe() async {
        await sut.requestWeatherData()
        
        DispatchQueue.main.async {
            XCTAssertNotNil(self.sut.forecast)
        }
        
        }
        
       
//        XCTAssertEqual(sut.forecast, [ForecastDay(weekDay: "lol", hourForecast: [ForecastDayInfo(minTemp: 10.0, maxTemp: 10.0, icon: "lol", time: "lol", name: "lol", temp: 10.0, description: "lol", wind: 0.0, date: "lol", simpleDescription: "lol")])])
    
    
    func setArray(){
        let info = ForecastDay(weekDay: "Monday", hourForecast: [ForecastDayInfo(minTemp: 10.0, maxTemp: 20.0, icon: "lol", time: "12", name: "NewYork", temp: 22.0, description: "Lepo vreme", wind: 30.0, date: "22.2", simpleDescription: "Super")])
        sut.forecast.append(info)
    }
    
    private func jsonData() -> Data {
        """
      {
        "weekDay" : "Monday",
        "hourForecast": [
          {
            
            "minTemp": 2.0,
           "maxTemp":3.0,
         "icon": "stain",
        "time": "11h",
         "name" : "NewYork",
         "temp" : 3.0,
          "description": "lol",
         "wind" : 3.0,
         "date" : "lol",
         "simpleDescription": "idegas"
            
      }
          
          ]
          
      }
""".data(using: .utf8)!
        
    }
 
}
