//
//  Weather.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 06.12.2022.
//

import SwiftUI
import Foundation

struct Weather: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}
