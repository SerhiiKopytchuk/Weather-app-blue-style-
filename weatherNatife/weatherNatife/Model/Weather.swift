//
//  Weather.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import Foundation

// MARK: - Weather
struct Weather: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Current
struct Current: Codable {
    let lastUpdatedEpoch: Int
    let tempC: Double
    let condition: Condition
    let windKph, windDegree: Double
    let windDir: String
    let humidity: Int
    let feelslikeC: Double


    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case humidity
        case feelslikeC = "feelslike_c"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - ForecastDay
struct Forecastday: Codable, Identifiable {

    let id = UUID().uuidString
    let date: String
    let dateEpoch: Int
    let day: Day
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, hour
    }
}

extension Forecastday: Equatable {
    static func == (lhs: Forecastday, rhs: Forecastday) -> Bool {
        lhs.id == rhs.id
    }
}

extension Forecastday {
    var avgWind: Double {
        var result = 0.0
        self.hour.forEach { oneHour in
            result += oneHour.windKph
        }
        return result/Double(hour.count)
    }
}
extension Forecastday {
    var maxAndMin: String {
        "\(self.day.maxtempC)°/\(self.day.mintempC)°C"
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, mintempC: Double
    let avgtempC, maxwindKph: Double
    let avghumidity: Int
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case maxwindKph = "maxwind_kph"
        case avghumidity
        case condition
    }
}

// MARK: - Hour
struct Hour: Codable, Identifiable {

    let id = UUID().uuidString
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let condition: Condition
    let windKph: Double
    let windDir: String
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
        case windDir = "wind_dir"
        case humidity
    }
}


extension Hour: Equatable {
    static func == (lhs: Hour, rhs: Hour) -> Bool {
        lhs.id == rhs.id
    }

}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
