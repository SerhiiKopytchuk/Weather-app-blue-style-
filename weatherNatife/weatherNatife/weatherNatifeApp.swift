//
//  weatherNatifeApp.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI

@main
struct weatherNatifeApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherViewModel = WeatherViewModel()

            ContentView()
                .environmentObject(weatherViewModel)
                .onAppear {
                    weatherViewModel.getForecastWeather { _ in }
                    weatherViewModel.getCurrentWeather { _ in }
                }
        }
    }
}
