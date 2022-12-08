//
//  WeatherViewModel.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import MapKit
import Combine

class WeatherViewModel: ObservableObject {

    // MARK: - vars

    let userDefaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    var locationManager = LocationManager()

    let requestedDataWebSite = "https://api.weatherapi.com/v1/"
    let key = "d0a9ecd662d7487b911111422221903"

    enum UserDefaultsKeys: String {
        case lastSavedLatitude, lastSavedLongitude
    }

    @Published var lastSavedLocation: CLLocationCoordinate2D?

    @Published var weather: Weather?

    @Published var locations = [SearchLocation]()

    @Published var lastMark: Mark?

    @Published var isShowLoader = false

    @Published var alertMessage = ""

    var weatherUrl = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=d0a9ecd662d7487b911111422221903&q=London&days=10&aqi=no&alerts=no")

    // MARK: - computed properties

    var requestForecastString: String {
        return "\(requestedDataWebSite)forecast.json?key=\(key)&"
    }

    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }

    // MARK: - init

    init() {
        if let lastSavedLat = userDefaults.object(forKey: UserDefaultsKeys.lastSavedLatitude.rawValue) as? Double {
            if let lastSavedLong = userDefaults.object(forKey: UserDefaultsKeys.lastSavedLongitude.rawValue) as? Double {
                self.lastSavedLocation = CLLocationCoordinate2D(latitude: lastSavedLat, longitude: lastSavedLong)
                self.weatherUrl = URL(string: "\(requestForecastString)&q=\(lastSavedLat),\(lastSavedLong)&days=10&aqi=no&alerts=no")
            }
        }
    }

    // MARK: - functions

    func changeLocation(cityName: String) {
        self.weatherUrl = URL(string: "\(requestForecastString)&q=\(cityName)&days=10&aqi=no&alerts=no")
        self.getWeather { _ in
        }
    }

    func changeLocation(location: CLLocationCoordinate2D) {
        self.weatherUrl = URL(string: "\(requestForecastString)q=\(location.latitude),\(location.longitude)&days=10&aqi=no&alerts=no")
        lastMark = Mark(coordinate: location)
        getWeather { _ in }
    }

    func switchToCurrentLocation(accessToLocationDenied: () -> Void) {
        if let _ = locationManager.lastLocation {
            self.weatherUrl = URL(string: "\(requestForecastString)&q=\(userLatitude),\(userLongitude)&days=10&aqi=no&alerts=no")
            getWeather { _ in }
        } else {
            accessToLocationDenied()
        }
    }
    
    func getPlacesList(text: String) {
        guard let locationURL = URL(string: "\(requestedDataWebSite)search.json?key=\(key)&q=\(text)") else { return }
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            let task = URLSession.shared.dataTask(with: locationURL) { data, response, error in
                guard let data, error == nil else { return }

                DispatchQueue.main.async {
                    do {
                        self?.locations = try JSONDecoder().decode([SearchLocation].self, from: data)
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }


    func getWeather(competition: (Error?) -> Void) {
        showLoader()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let weatherUrl = self?.weatherUrl else { return }
            let task = URLSession.shared.dataTask(with: weatherUrl) { data, response, error in
                guard let data, error == nil else { return }
                DispatchQueue.main.async {
                    do {
                        self?.weather = try JSONDecoder().decode(Weather.self, from: data)

                        self?.lastSavedLocation = CLLocationCoordinate2D(latitude: self?.weather?.location.lat ?? 0,
                                                                         longitude: self?.weather?.location.lon ?? 0)


                        self?.saveCoordinates(coordinates: self?.lastSavedLocation ?? CLLocationCoordinate2D(latitude: 0,
                                                                                                             longitude: 0))
                        self?.notificationCenter.post(name: Notification.Name("receivedData"), object: nil)
                        self?.hideLoader()
                    } catch {
                        print(error)
                        self?.hideLoader()
                    }
                }

            }
            task.resume()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if self.isShowLoader == true {
                withAnimation(.easeInOut) {
                    self.alertMessage = "Check your internet connection. Failed to load content"
                    self.isShowLoader = false
                }
            }
        }
    }

    private func showLoader() {
        withAnimation(.easeInOut) {
            isShowLoader = true
        }
    }

    private func hideLoader() {
        withAnimation(.easeInOut) {
            isShowLoader = false
        }
    }

    func saveCoordinates(coordinates: CLLocationCoordinate2D) {
        userDefaults.set(coordinates.latitude, forKey: UserDefaultsKeys.lastSavedLatitude.rawValue)
        userDefaults.set(coordinates.longitude, forKey: UserDefaultsKeys.lastSavedLongitude.rawValue)
    }
}
