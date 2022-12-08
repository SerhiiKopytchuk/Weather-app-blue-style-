//
//  Hour.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation

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
