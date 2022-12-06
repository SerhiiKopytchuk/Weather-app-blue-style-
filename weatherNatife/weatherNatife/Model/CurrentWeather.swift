//
//  CurrentWeather.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import Foundation

// MARK: - Welcome
struct CurrentWeather: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let dt: Int
    let timezone, id: Int
    let name: String
    let cod: Int
}


// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax, humidity: Double

    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
