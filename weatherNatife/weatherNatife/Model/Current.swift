//
//  Current.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation

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
