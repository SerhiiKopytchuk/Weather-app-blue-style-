//
//  ForecastDay.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation

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
