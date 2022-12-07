//
//  WeatherViewModel.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI

class WeatherViewModel: ObservableObject {

    @Published var weather: Weather?

    var weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=d0a9ecd662d7487b911111422221903&q=London&days=10&aqi=no&alerts=no")

    let notificationCenter = NotificationCenter.default

    var locationManager = LocationManager()

    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }

    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }



    func getWeather(competition: (Error?) -> Void) {
        guard let weatherUrl else { return }
        let task = URLSession.shared.dataTask(with: weatherUrl) { data, response, error in
            guard let data, error == nil else { return }

            DispatchQueue.main.async { [self] in

                do {
                    self.weather = try JSONDecoder().decode(Weather.self, from: data)
                    self.notificationCenter.post(name: Notification.Name("receivedData"), object: nil)
                } catch {
                    print(error)
                }
            }

        }
        task.resume()
    }

    func getCurrentLocation() {
        self.weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=d0a9ecd662d7487b911111422221903&q=\(userLatitude),\(userLongitude)&days=10&aqi=no&alerts=no")
        getWeather { _ in }
    }
    
}
