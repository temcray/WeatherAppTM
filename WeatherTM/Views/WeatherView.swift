//
//  WeatherView.swift
//  WeatherTM
//
//  Created by Tatiana6mo on 3/23/26.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var weatherViewModel: WeatherViewModel = WeatherViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                TextField("Enter a city", text: $weatherViewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                
                
                //Important Part
                Button("Get Weather") {
                    Task {
                        await weatherViewModel.searchWeather()
                    }
                }
                
                .buttonStyle(.borderedProminent)
                
                if weatherViewModel.isLoading {
                    ProgressView("Loading...")
                }
                
                if !weatherViewModel.errorMessage.isEmpty {
                    Text(weatherViewModel.errorMessage)
                        .foregroundStyle(.red)
                }
                
                if !weatherViewModel.cityName.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(weatherViewModel.cityName)
                            .font(.title2)
                            .bold()
                        
                        
                        Text(weatherViewModel.temperatureText)
                        Text(weatherViewModel.windText)
                        Text(weatherViewModel.timeText)
                        
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Spacer()
                
                
                
            }
            
            .padding()
            .navigationTitle("Weather")
        }
    }
}
