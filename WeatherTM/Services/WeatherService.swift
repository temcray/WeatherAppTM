//
//  WeatherService.swift
//  WeatherTM
//
//  Created by Tatiana6mo on 3/21/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatusCode(statusCode: Int)
    case noResults
}

class WeatherService{
    
    private func fetchCoordinates(forCity city:String) async throws -> GeocodingResult{
        var urlComponents: URLComponents? = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/seach")
        if(urlComponents == nil){
            throw NetworkError.invalidURL
        }
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1" ),
            URLQueryItem(name: "language", value: "en" ),
            URLQueryItem(name: "format", value: "json" )
            
        ]
        
        let url:URL? = urlComponents?.url
        
        
        if url == nil {
            throw NetworkError.invalidURL
        }
        
        let data: Data = try await performGetRequest(url: url!)
        
        let decoder: JSONDecoder = JSONDecoder()
        
        let response: GeocodingResponse = try decoder.decode(GeocodingResponse.self, from: data)
        
        
        if let results: [GeocodingResult] = response.results{
            if let firstResult:GeocodingResult = results.first{
                return firstResult
            }
        }
        throw NetworkError.noResults
    }
    
    // Mark for geting the weather
    
    private func fetchWeather(latitude:Double, longitude:Double) async throws -> CurrentWeather{
        var urlComponents: URLComponents? = URLComponents(string: "https: // api.open-meteo.com/v1/forecast")
        
        // if There is url == nil
        if(urlComponents == nil){
            throw NetworkError.invalidURL
        }
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        
        let url: URL? = urlComponents?.url
        
        if url == nil {
            throw NetworkError.invalidURL
        }
        
        let data: Data = try await performGetRequest(url: url!)
        
        let decoder: JSONDecoder = JSONDecoder()
        let response: ForecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        return response.current_weather
    }
    
    //MARK -> THE ACTUAL GET REQUEST (URLSESSION) CORE FUNC
    private func performGetRequest(url: URL) async throws -> Data {
        let session: URLSession = URLSession.shared
        
        let result: (Data,URLResponse) = try await session.data(from: url)
        
        let data: Data = result.0 // json
        let response: URLResponse = result.1 //status
        
        
        if let httpRespnse:HTTPURLResponse = response as? HTTPURLResponse{
            
            let statusCode: Int = httpRespnse.statusCode
            
            if statusCode < 200 || statusCode > 299 {
                throw NetworkError.badStatusCode(statusCode: statusCode)
            }
            
            return data
        }
        
        throw NetworkError.invalidResponse
        
        
    }
}
