//
//  MockURLSession.swift
//  WeatherTests
//
//  Created by Nikola Andrijasevic on 30.3.22..
//
import XCTest
import Foundation
@testable import Weather

class MockURLSession: URLSessionProtocol{
    var result = Result<Data,Error>.success(Data())
   
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try(result.get(),URLResponse())
        }
    }

struct TestError : LocalizedError {
    let message: String
    var errorDescription: String? {message}
}
