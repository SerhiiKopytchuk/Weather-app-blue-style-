//
//  weatherNatifeApp.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI

@main
struct weatherNatifeApp: App {

    let weatherViewModel = WeatherViewModel()

    init() {
        weatherViewModel.getWeather { error in
            print(error ?? "")
        }
    }

    var body: some Scene {
        WindowGroup {

            ContentView()
                .environmentObject(weatherViewModel)
        }
    }
}
