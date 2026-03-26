//
//  WeatherModel.swift
//  WeatherTM
//
//  Created by Tatiana6mo on 3/21/26.
//
import Foundation

// MARK GEOCODING (CITY - LATITUDE/LONGITUDE
struct GeocodingResponse: Codable {
    
    let results: [GeocodingResult]?
}

struct GeocodingResult: Codable{
    let name: String
    let latitude: Double
    let longitude: Double
}

// Mark: Weather -> (Latitude/Longitude) -> Current Weather

struct ForecastResponse: Codable {
    
    let current_weather: CurrentWeather
}

struct CurrentWeather: Codable {
    
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
    
}
    
    

 
