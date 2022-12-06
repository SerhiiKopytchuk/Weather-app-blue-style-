//
//  WeatherViewModel.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI

class WeatherViewModel: ObservableObject {

    @Published var weather: Weather?

    let weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=d0a9ecd662d7487b911111422221903&q=London&days=10&aqi=no&alerts=no")

    var maxAndMin: String {
        let max = String(self.weather?.forecast.forecastday.first?.day.maxtempC ?? 0.0)
        let min = String(self.weather?.forecast.forecastday.first?.day.mintempC ?? 0.0)

        return "\(max)°/\(min)°"
    }


    func getWeather(competition: (Error?) -> Void) {
        guard let weatherUrl else { return }
        let task = URLSession.shared.dataTask(with: weatherUrl) { data, response, error in
            guard let data, error == nil else { return }

            DispatchQueue.main.async {

                do {
                    self.weather = try JSONDecoder().decode(Weather.self, from: data)
                } catch {
                    print(error)
                }
            }

        }
        task.resume()
    }
    
}
