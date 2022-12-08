//
//  SearchLocation.swift
//  weatherNatife
//
//  Created by Serhii Kopytchuk on 08.12.2022.
//

import Foundation

struct SearchLocation: Codable, Identifiable {
    var id: Int
    let name, region: String
    let country: String
    let lat, lon: Double
}
