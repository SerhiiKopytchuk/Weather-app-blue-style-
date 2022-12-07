//
//  Location.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 07.12.2022.
//

import SwiftUI
import Foundation

// MARK: - LocationElement
struct SearchLocation: Codable, Identifiable {
    var id: Int
    let name, region: String
    let country: String
    let lat, lon: Double
}
