//
//  Day.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation

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
