//
//  WeatherViewModel.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI

class WeatherViewModel: ObservableObject {

    @Published var currentWeather: CurrentWeather?
    @Published var forecastWeather: ForecastWeather?

    let currentWeatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=33.44&lon=-94.04&appid=6b8ea2926534cc23b0764be10c8ce4b7&units=metric")
    let forecastWeatherUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=6b8ea2926534cc23b0764be10c8ce4b7&units=metric")

    func getCurrentWeather(competition: (Error?) -> Void) {
        guard let currentWeatherUrl else { return }
        let task = URLSession.shared.dataTask(with: currentWeatherUrl) { data, response, error in
            guard let data, error == nil else { return }

            DispatchQueue.main.async {

                do {
                    self.currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                } catch {
                    print(error)
                }
            }

        }
        task.resume()
    }

    func getForecastWeather(competition: (Error?) -> Void) {
        guard let forecastWeatherUrl else { return }
        let task = URLSession.shared.dataTask(with: forecastWeatherUrl) { data, response, error in
            guard let data, error == nil else { return }

            DispatchQueue.main.async {

                do {
                    self.forecastWeather = try JSONDecoder().decode(ForecastWeather.self, from: data)

                } catch {
                    print(error)
                }
            }

        }
        task.resume()
    }

}
